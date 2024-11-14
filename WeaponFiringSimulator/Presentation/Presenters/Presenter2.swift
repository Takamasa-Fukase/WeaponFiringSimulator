//
//  Presenter2.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 13/11/24.
//

import Foundation

protocol PresenterInterface2 {
    func viewDidLoad()
    func fireButtonTapped()
    func reloadButtonTapped()
    func weaponSelected(weaponId: Int)
}

final class Presenter2 {
    private weak var view: ViewControllerInterface2?
    private let defaultWeaponGetUseCase: DefaultWeaponGetUseCaseInterface
    private let weaponDetailGetUseCase: WeaponDetailGetUseCaseInterface
    private let weaponFireUseCase: WeaponFireUseCaseInterface
    private let weaponReloadUseCase: WeaponReloadUseCaseInterface
    
    private var currentWeaponData: CurrentWeaponData?
    
    
    
    // TODO: #if TEST的な分岐を追加して、プロダクトコードからはアクセス不可にする
//    func getBulletsCount() -> Int {
//        return bulletsCount
//    }
//    func getIsReloading() -> Bool {
//        return isReloading
//    }
//    func setBulletsCount(_ bulletsCount: Int) {
//        self.bulletsCount = bulletsCount
//    }
//    func setIsReloading(_ isReloading: Bool) {
//        self.isReloading = isReloading
//    }
    // ユニットテスト専用のコード
    // TODO: #if TEST的な分岐を追加して、プロダクトコードからはアクセス不可にする
    
    
    
    init(
        view: ViewControllerInterface2,
        defaultWeaponGetUseCase: DefaultWeaponGetUseCaseInterface,
        weaponDetailGetUseCase: WeaponDetailGetUseCaseInterface,
        weaponFireUseCase: WeaponFireUseCaseInterface,
        weaponReloadUseCase: WeaponReloadUseCaseInterface
    ) {
        self.view = view
        self.defaultWeaponGetUseCase = defaultWeaponGetUseCase
        self.weaponDetailGetUseCase = weaponDetailGetUseCase
        self.weaponFireUseCase = weaponFireUseCase
        self.weaponReloadUseCase = weaponReloadUseCase
    }
    
    private func showSelectedWeapon(_ currentWeaponData: CurrentWeaponData) {
        self.currentWeaponData = currentWeaponData
        view?.showWeaponImage(name: currentWeaponData.weaponImageName)
        view?.showBulletsCountImage(name: currentWeaponData.bulletsCountImageName())
        view?.playShowingSound(type: currentWeaponData.showingSound)
    }
}

extension Presenter2: PresenterInterface2 {
    func viewDidLoad() {
        do {
            let currentWeaponData = try defaultWeaponGetUseCase.execute()
            showSelectedWeapon(currentWeaponData)
            
        } catch {
            print("defaultWeaponGetUseCase error: \(error)")
        }
    }
    
    func fireButtonTapped() {
        let request = WeaponFireRequest(
            weaponId: currentWeaponData?.id ?? 0,
            bulletsCount: currentWeaponData?.bulletsCount ?? 0,
            isReloading: currentWeaponData?.isReloading ?? false
        )
        do {
            try weaponFireUseCase.execute(
                request: request,
                onFired: { response in
                    currentWeaponData?.bulletsCount = response.bulletsCount
                    view?.playFireSound(type: currentWeaponData?.firingSound ?? .pistolShoot)
                    view?.showBulletsCountImage(name: currentWeaponData?.bulletsCountImageName() ?? "")
                    
                    if response.needsAutoReload {
                        // リロードを自動的に実行
                        view?.executeAutoReload()
                    }
                },
                onCanceled: {
                    if let noBulletsSound = currentWeaponData?.noBulletsSound {
                        view?.playNoBulletsSound(type: noBulletsSound)
                    }
                })
        } catch {
            print("weaponFireUseCase error: \(error)")
        }
    }
    
    func reloadButtonTapped() {
        let request = WeaponReloadRequest(
            weaponId: currentWeaponData?.id ?? 0,
            bulletsCount: currentWeaponData?.bulletsCount ?? 0,
            isReloading: currentWeaponData?.isReloading ?? false
        )
        do {
            try weaponReloadUseCase.execute(
                request: request,
                onReloadStarted: { response in
                    currentWeaponData?.isReloading = response.isReloading
                    view?.playReloadSound(type: currentWeaponData?.reloadingSound ?? .pistolReload)
                },
                onReloadEnded: { [weak self] response in
                    self?.currentWeaponData?.bulletsCount = response.bulletsCount
                    self?.currentWeaponData?.isReloading = response.isReloading
                    self?.view?.showBulletsCountImage(name: self?.currentWeaponData?.bulletsCountImageName() ?? "")
                })
        } catch {
            print("weaponReloadUseCase error: \(error)")
        }
    }
    
    func weaponSelected(weaponId: Int) {
        let request = WeaponDetailGetRequest(weaponId: weaponId)
        do {
            let currentWeaponData = try weaponDetailGetUseCase.execute(request: request)
            showSelectedWeapon(currentWeaponData)
            
        } catch {
            print("WeaponDetailGetRequest error: \(error)")
        }
    }
}
