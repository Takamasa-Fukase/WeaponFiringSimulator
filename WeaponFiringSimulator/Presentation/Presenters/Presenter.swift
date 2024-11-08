//
//  Presenter.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

protocol PresenterInterface {
    func viewDidLoad()
    func fireButtonTapped(
        weaponId: Int,
        bulletsCount: Int,
        isReloading: Bool
    )
    func reloadButtonTapped(
        weaponId: Int,
        bulletsCount: Int,
        isReloading: Bool
    )
    func changeWeaponButtonTapped(nextWeaponId: Int)
}

final class Presenter {
    private weak var view: ViewControllerInterface?
    private let weaponListGetUseCase: WeaponListGetUseCaseInterface
    private let weaponFireUseCase: WeaponFireUseCaseInterface
    private let weaponReloadUseCase: WeaponReloadUseCaseInterface
    private let weaponChangeUseCase: WeaponChangeUseCaseInterface
    
    init(
        view: ViewControllerInterface,
        weaponListGetUseCase: WeaponListGetUseCaseInterface,
        weaponFireUseCase: WeaponFireUseCaseInterface,
        weaponReloadUseCase: WeaponReloadUseCaseInterface,
        weaponChangeUseCase: WeaponChangeUseCaseInterface
    ) {
        self.view = view
        self.weaponListGetUseCase = weaponListGetUseCase
        self.weaponFireUseCase = weaponFireUseCase
        self.weaponReloadUseCase = weaponReloadUseCase
        self.weaponChangeUseCase = weaponChangeUseCase
    }
    
    private func setupAndShowNewWeapon(
        weaponId: Int,
        bulletsCount: Int,
        isReloading: Bool,
        weaponImageName: String,
        bulletsCountImageName: String,
        showingSound: SoundType
    ) {
        view?.updateBulletsCount(bulletsCount)
        view?.updateReloadingFlag(isReloading)
        view?.showWeaponImage(name: weaponImageName)
        view?.showBulletsCountImage(name: bulletsCountImageName)
        view?.playShowingSound(type: showingSound)
    }
}

extension Presenter: PresenterInterface {
    func viewDidLoad() {
        let weaponListItems = weaponListGetUseCase.execute().weaponListItems
        view?.showWeaponList(weaponListItems)
        view?.selectInitialItem(at: IndexPath(row: 0, section: 0))
    }
    
    func fireButtonTapped(
        weaponId: Int,
        bulletsCount: Int,
        isReloading: Bool
    ) {
        let request = WeaponFireRequest(
            weaponId: weaponId,
            bulletsCount: bulletsCount,
            isReloading: isReloading
        )
        do {
            try weaponFireUseCase.execute(
                request: request,
                onFired: { response in
                    view?.updateBulletsCount(response.bulletsCount)
                    view?.playFireSound(type: response.firingSound)
                    view?.showBulletsCountImage(name: response.bulletsCountImageName)
                    
                    if response.needsAutoReload {
                        // リロードを自動的に実行
                        view?.executeAutoReload()
                    }
                },
                onCanceled: { response in
                    if let noBulletsSound = response.noBulletsSound {
                        view?.playNoBulletsSound(type: noBulletsSound)
                    }
                })
        } catch {
            print("weaponFireUseCase error: \(error)")
        }
    }
    
    func reloadButtonTapped(
        weaponId: Int,
        bulletsCount: Int,
        isReloading: Bool
    ) {
        let request = WeaponReloadRequest(
            weaponId: weaponId,
            bulletsCount: bulletsCount,
            isReloading: isReloading
        )
        do {
            try weaponReloadUseCase.execute(
                request: request,
                onReloadStarted: { response in
                    view?.playReloadSound(type: response.reloadingSound)
                    view?.updateReloadingFlag(response.isReloading)
                },
                onReloadEnded: { [weak self] response in
                    self?.view?.updateBulletsCount(response.bulletsCount)
                    self?.view?.updateReloadingFlag(response.isReloading)
                    self?.view?.showBulletsCountImage(name: response.bulletsCountImageName)
                })
        } catch {
            print("weaponReloadUseCase error: \(error)")
        }
    }
    
    func changeWeaponButtonTapped(nextWeaponId: Int) {
        let request = WeaponChangeRequest(nextWeaponId: nextWeaponId)
        do {
            try weaponChangeUseCase.execute(
                request: request,
                onCompleted: { response in
                    setupAndShowNewWeapon(weaponId: response.weaponId,
                               bulletsCount: response.bulletsCount,
                               isReloading: response.isReloading,
                               weaponImageName: response.weaponImageName,
                               bulletsCountImageName: response.bulletsCountImageName,
                               showingSound: response.showingSound)
                })
        } catch {
            print("weaponChangeUseCase error: \(error)")
        }
    }
}
