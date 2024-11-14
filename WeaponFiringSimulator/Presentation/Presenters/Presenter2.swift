//
//  Presenter2.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 13/11/24.
//

import Foundation

protocol PresenterInterface2 {
    var weaponListItems: [WeaponListItem] { get }
    func viewDidLoad()
    func fireButtonTapped(selectedIndex: Int)
    func reloadButtonTapped(selectedIndex: Int)
    func changeWeaponButtonTapped(nextWeaponId: Int)
}

final class Presenter2 {
    private weak var view: ViewControllerInterface2?
    private let weaponListGetUseCase: WeaponListGetUseCaseInterface
    private let weaponFireUseCase: WeaponFireUseCaseInterface
    private let weaponReloadUseCase: WeaponReloadUseCaseInterface
    private let weaponChangeUseCase: WeaponChangeUseCaseInterface
    
    private(set) var weaponListItems: [WeaponListItem] = []
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
    func setWeaponListItems(_ weaponListItems: [WeaponListItem]) {
        self.weaponListItems = weaponListItems
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
}

extension Presenter2: PresenterInterface2 {
    func viewDidLoad() {
        weaponListItems = weaponListGetUseCase.execute().weaponListItems
        view?.showWeaponList()
        view?.selectInitialItem(at: IndexPath(row: 0, section: 0))
    }
    
    func fireButtonTapped(selectedIndex: Int) {
        let request = WeaponFireRequest(
            weaponId: self.weaponListItems[selectedIndex].weaponId,
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
    
    func reloadButtonTapped(selectedIndex: Int) {
        let request = WeaponReloadRequest(
            weaponId: self.weaponListItems[selectedIndex].weaponId,
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
    
    func changeWeaponButtonTapped(nextWeaponId: Int) {
        let request = WeaponChangeRequest(nextWeaponId: nextWeaponId)
        do {
            try weaponChangeUseCase.execute(
                request: request,
                onCompleted: { response in
                    self.weaponDataModel = response.data
                    self.bulletsCount = response.data.capacity
                    self.isReloading = false
                    view?.showWeaponImage(name: response.data.weaponImageName)
                    view?.showBulletsCountImage(name: response.data.bulletsCountImageBaseName + String(response.data.capacity))
                    view?.playShowingSound(type: response.data.showingSound)
                })
        } catch {
            print("weaponChangeUseCase error: \(error)")
        }
    }
}
