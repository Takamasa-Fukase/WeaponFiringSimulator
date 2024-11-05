//
//  Presenter.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

class Presenter {
    weak var view: ViewController?
    let domainLayer = DomainLayer()
    
    var weaponType: WeaponType = .pistol
    var bulletsCount: Int = WeaponType.pistol.capacity
    var isReloading = false
    
    private func resetProperties() {
        bulletsCount = weaponType.capacity
        isReloading = false
    }
    
    private func showWeapon() {
        view?.showWeaponImage(type: weaponType)
        view?.showBulletsCountImage(type: weaponType, count: bulletsCount)
        view?.playShowingSound(type: weaponType)
    }
}

extension Presenter {
    func viewDidLoad() {
        showWeapon()
    }
    
    func fireButtonTapped() {
        if domainLayer.canFire(
            type: weaponType,
            bulletsCount: bulletsCount,
            isReloading: isReloading
        ) {
            print("fireButtonTapped 撃てる")
            // 撃てる
            bulletsCount -= 1
            view?.playFireSound(type: weaponType)
            view?.showBulletsCountImage(type: weaponType, count: bulletsCount)
            
            if domainLayer.shouldExecuteAutomaticReload(
                type: weaponType,
                bulletsCount: bulletsCount,
                isReloading: isReloading
            ) {
                // リロードを自動的に実行
                reloadButtonTapped()
            }
            
        }else {
            print("fireButtonTapped 撃てない")
            // 撃てない
            view?.playNoBulletsSound(type: weaponType)
        }
    }
    
    func reloadButtonTapped() {
        if domainLayer.canReload(
            type: weaponType,
            bulletsCount: bulletsCount,
            isReloading: isReloading
        ) {
            print("reloadButtonTapped リロードできる")
            // リロードできる
            isReloading = true
            view?.playReloadSound(type: self.weaponType)
            DispatchQueue.main.asyncAfter(deadline: .now() + self.weaponType.reloadWaitingTime, execute: {
                self.bulletsCount = self.weaponType.capacity
                self.view?.showBulletsCountImage(type: self.weaponType, count: self.bulletsCount)
                self.isReloading = false
            })
            
        }else {
            // リロードできない
            print("reloadButtonTapped リロードできない")
        }
    }
    
    func changeWeaponButtonTapped() {
        switch weaponType {
        case .pistol:
            weaponType = .bazooka
        case .bazooka:
            weaponType = .pistol
        }
        
        resetProperties()
        showWeapon()
    }
}
