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
    
    private var weaponDataModel: WeaponDataModel?
    private var bulletsCount: Int = 0
    private var isReloading = false
    
    
    
    // TODO: #if TEST的な分岐を追加して、プロダクトコードからはアクセス不可にする
    func getBulletsCount() -> Int {
        return bulletsCount
    }
    func getIsReloading() -> Bool {
        return isReloading
    }
    func setBulletsCount(_ bulletsCount: Int) {
        self.bulletsCount = bulletsCount
    }
    func setIsReloading(_ isReloading: Bool) {
        self.isReloading = isReloading
    }
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
    
    private func showSelectedWeapon(weaponDataModel: WeaponDataModel) {
        print("showSelectedWeapon: \(weaponDataModel)")
        self.weaponDataModel = weaponDataModel
        self.bulletsCount = weaponDataModel.capacity
        self.isReloading = false
        view?.showWeaponImage(name: weaponDataModel.weaponImageName)
        view?.showBulletsCountImage(name: weaponDataModel.bulletsCountImageBaseName + String(weaponDataModel.capacity))
        view?.playShowingSound(type: weaponDataModel.showingSound)
    }
}

extension Presenter2: PresenterInterface2 {
    func viewDidLoad() {
        do {
            let weaponDataModel = try defaultWeaponGetUseCase.execute()
            showSelectedWeapon(weaponDataModel: weaponDataModel)
            
        } catch {
            print("defaultWeaponGetUseCase error: \(error)")
        }
    }
    
    func fireButtonTapped() {
        let request = WeaponFireRequest(
            weaponId: weaponDataModel?.id ?? 0,
            bulletsCount: self.bulletsCount,
            isReloading: self.isReloading
        )
        do {
            try weaponFireUseCase.execute(
                request: request,
                onFired: { response in
                    self.bulletsCount = response.bulletsCount
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
    
    func reloadButtonTapped() {
        let request = WeaponReloadRequest(
            weaponId: weaponDataModel?.id ?? 0,
            bulletsCount: self.bulletsCount,
            isReloading: self.isReloading
        )
        do {
            try weaponReloadUseCase.execute(
                request: request,
                onReloadStarted: { response in
                    view?.playReloadSound(type: response.reloadingSound)
                    self.isReloading = response.isReloading
                },
                onReloadEnded: { [weak self] response in
                    self?.bulletsCount = response.bulletsCount
                    self?.isReloading = response.isReloading
                    self?.view?.showBulletsCountImage(name: response.bulletsCountImageName)
                })
        } catch {
            print("weaponReloadUseCase error: \(error)")
        }
    }
    
    func weaponSelected(weaponId: Int) {
        let request = WeaponDetailGetRequest(weaponId: weaponId)
        print("request: \(request)")
        do {
            let weaponDataModel = try weaponDetailGetUseCase.execute(request: request)
            print("weaponDataModel: \(weaponDataModel)")
            showSelectedWeapon(weaponDataModel: weaponDataModel)
            
        } catch {
            print("WeaponDetailGetRequest error: \(error)")
        }
    }
}
