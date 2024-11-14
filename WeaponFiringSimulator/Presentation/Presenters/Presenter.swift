//
//  Presenter.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 13/11/24.
//

import Foundation

protocol PresenterInterface {
    func viewDidLoad()
    func fireButtonTapped()
    func reloadButtonTapped()
    func weaponSelected(weaponId: Int)
}

final class Presenter {
    private weak var view: ViewControllerInterface?
    private let weaponResourceGetUseCase: WeaponResourceGetUseCaseInterface
    private let weaponActionExecuteUseCase: WeaponActionExecuteUseCaseInterface
    
    private var currentWeaponData: CurrentWeaponData?
    
    
    
    // TODO: #if TEST的な分岐を追加して、プロダクトコードからはアクセス不可にする
    func getCurrentWeaponData() -> CurrentWeaponData? {
        return currentWeaponData
    }
    func setCurrentWeaponData(_ currentWeaponData: CurrentWeaponData?) {
        self.currentWeaponData = currentWeaponData
    }
    // ↑ ユニットテスト専用のコード
    // TODO: #if TEST的な分岐を追加して、プロダクトコードからはアクセス不可にする
    
    
    
    init(
        view: ViewControllerInterface,
        weaponResourceGetUseCase: WeaponResourceGetUseCaseInterface,
        weaponActionExecuteUseCase: WeaponActionExecuteUseCaseInterface
    ) {
        self.view = view
        self.weaponResourceGetUseCase = weaponResourceGetUseCase
        self.weaponActionExecuteUseCase = weaponActionExecuteUseCase
    }
    
    private func showSelectedWeapon(_ currentWeaponData: CurrentWeaponData) {
        self.currentWeaponData = currentWeaponData
        view?.showWeaponImage(name: self.currentWeaponData?.weaponImageName ?? "")
        view?.showBulletsCountImage(name: self.currentWeaponData?.bulletsCountImageName() ?? "")
        view?.playSound(type: self.currentWeaponData?.showingSound ?? .pistolSet)
    }
}

extension Presenter: PresenterInterface {
    func viewDidLoad() {
        do {
            let currentWeaponData = try weaponResourceGetUseCase.getDefaultWeaponDetail()
            showSelectedWeapon(currentWeaponData)
            
        } catch {
            print("defaultWeaponGetUseCase error: \(error)")
        }
    }
    
    func fireButtonTapped() {
        weaponActionExecuteUseCase.fireWeapon(
            bulletsCount: currentWeaponData?.bulletsCount ?? 0,
            isReloading: currentWeaponData?.isReloading ?? false,
            reloadType: currentWeaponData?.reloadType ?? .manual,
            onFired: { response in
                currentWeaponData?.bulletsCount = response.bulletsCount
                view?.playSound(type: currentWeaponData?.firingSound ?? .pistolShoot)
                view?.showBulletsCountImage(name: currentWeaponData?.bulletsCountImageName() ?? "")
                
                if response.needsAutoReload {
                    // リロードを自動的に実行
                    view?.executeAutoReload()
                }
            },
            onCanceled: {
                if let noBulletsSound = currentWeaponData?.noBulletsSound {
                    view?.playSound(type: noBulletsSound)
                }
            })
    }
    
    func reloadButtonTapped() {
        weaponActionExecuteUseCase.reloadWeapon(
            bulletsCount: currentWeaponData?.bulletsCount ?? 0,
            isReloading: currentWeaponData?.isReloading ?? false,
            capacity: currentWeaponData?.capacity ?? 0,
            reloadWaitingTime: currentWeaponData?.reloadWaitingTime ?? 0,
            onReloadStarted: { response in
                currentWeaponData?.isReloading = response.isReloading
                view?.playSound(type: currentWeaponData?.reloadingSound ?? .pistolReload)
            },
            onReloadEnded: { [weak self] response in
                self?.currentWeaponData?.bulletsCount = response.bulletsCount
                self?.currentWeaponData?.isReloading = response.isReloading
                self?.view?.showBulletsCountImage(name: self?.currentWeaponData?.bulletsCountImageName() ?? "")
            })
    }
    
    func weaponSelected(weaponId: Int) {
        do {
            let currentWeaponData = try weaponResourceGetUseCase.getWeaponDetail(of: weaponId)
            showSelectedWeapon(currentWeaponData)
            
        } catch {
            print("WeaponDetailGetRequest error: \(error)")
        }
    }
}
