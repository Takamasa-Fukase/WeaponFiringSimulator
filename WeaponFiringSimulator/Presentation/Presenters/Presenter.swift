//
//  Presenter.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

protocol PresenterInterface {
    func viewDidLoad()
    func fireButtonTapped()
    func reloadButtonTapped()
    func changeWeaponButtonTapped()
}

final class Presenter {
    private weak var view: ViewControllerInterface?
    private let initialWeaponGetUseCase: InitialWeaponGetUseCaseInterface
    private let weaponFireUseCase: WeaponFireUseCaseInterface
    private let weaponReloadUseCase: WeaponReloadUseCaseInterface
    private let weaponChangeUseCase: WeaponChangeUseCaseInterface
    
    private var weaponType: WeaponType = .pistol
    private var bulletsCount: Int = 0
    private var isReloading: Bool = false
    
    init(
        view: ViewControllerInterface,
        initialWeaponGetUseCase: InitialWeaponGetUseCaseInterface,
        weaponFireUseCase: WeaponFireUseCaseInterface,
        weaponReloadUseCase: WeaponReloadUseCaseInterface,
        weaponChangeUseCase: WeaponChangeUseCaseInterface
    ) {
        self.view = view
        self.initialWeaponGetUseCase = initialWeaponGetUseCase
        self.weaponFireUseCase = weaponFireUseCase
        self.weaponReloadUseCase = weaponReloadUseCase
        self.weaponChangeUseCase = weaponChangeUseCase
    }
    
    private func showWeapon(weaponImageName: String, bulletsCountImageName: String, showingSound: SoundType) {
        view?.showWeaponImage(name: weaponImageName)
        view?.showBulletsCountImage(name: bulletsCountImageName)
        view?.playShowingSound(type: showingSound)
    }
}

extension Presenter: PresenterInterface {
    func viewDidLoad() {
        do {
            try initialWeaponGetUseCase.execute(
                onCompleted: { response in
                    weaponType = response.weaponType
                    bulletsCount = response.bulletsCount
                    isReloading = response.isReloading
                    
                    showWeapon(weaponImageName: response.weaponImageName,
                               bulletsCountImageName: response.bulletsCountImageBaseName + String(response.bulletsCount),
                               showingSound: response.showingSound)
                })
        } catch {
            print("initialWeaponGetUseCase error: \(error)")
        }
    }
    
    func fireButtonTapped() {
        let request = WeaponFireRequest(
            weaponType: weaponType,
            bulletsCount: bulletsCount,
            isReloading: isReloading
        )
        do {
            try weaponFireUseCase.execute(
                request: request,
                onFired: { response in
                    bulletsCount = response.bulletsCount
                    view?.playFireSound(type: response.firingSound)
                    view?.showBulletsCountImage(name: response.bulletsCountImageBaseName + String(response.bulletsCount))
                    
                    if response.needsAutoReload {
                        // リロードを自動的に実行
                        reloadButtonTapped()
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
    
    func reloadButtonTapped() {
        let request = WeaponReloadRequest(
            weaponType: weaponType,
            bulletsCount: bulletsCount,
            isReloading: isReloading
        )
        do {
            try weaponReloadUseCase.execute(
                request: request,
                onReloadStarted: { response in
                    view?.playReloadSound(type: response.reloadingSound)
                    isReloading = response.isReloading
                },
                onReloadEnded: { [weak self] response in
                    self?.bulletsCount = response.bulletsCount
                    self?.isReloading = response.isReloading
                    self?.view?.showBulletsCountImage(name: response.bulletsCountImageBaseName + String(response.bulletsCount))
                })
        } catch {
            print("weaponReloadUseCase error: \(error)")
        }
    }
    
    func changeWeaponButtonTapped() {
        let request = WeaponChangeRequest(
            weaponType: weaponType
        )
        do {
            try weaponChangeUseCase.execute(
                request: request,
                onCompleted: { response in
                    weaponType = response.weaponType
                    bulletsCount = response.bulletsCount
                    isReloading = response.isReloading
                    
                    showWeapon(weaponImageName: response.weaponImageName,
                               bulletsCountImageName: response.bulletsCountImageBaseName + String(response.bulletsCount),
                               showingSound: response.showingSound)
                })
        } catch {
            print("weaponChangeUseCase error: \(error)")
        }
    }
}
