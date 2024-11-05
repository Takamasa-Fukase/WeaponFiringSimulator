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
    var bulletsCount: Int = 0
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
        print("Presenter viewDidLoad")
        showWeapon()
    }
    
    func fireButtonTapped() {
        print("Presenter fireButtonTapped")
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
            if bulletsCount <= 0 && weaponType == .bazooka {
                reloadButtonTapped()
            }
            
        }else {
            print("fireButtonTapped 撃てない")
            // 撃てない
            view?.playNoBulletsSound(type: weaponType)
        }
    }
    
    func reloadButtonTapped() {
        print("Presenter reloadButtonTapped")
        if domainLayer.canReload(
            type: weaponType,
            bulletsCount: bulletsCount,
            isReloading: isReloading
        ) {
            print("reloadButtonTapped リロードできる")
            // リロードできる
            isReloading = true
            bulletsCount = weaponType.capacity
            view?.playReloadSound(type: weaponType)
            view?.showBulletsCountImage(type: weaponType, count: bulletsCount)
            DispatchQueue.main.asyncAfter(deadline: .now() + self.weaponType.reloadWaitingTime, execute: {
                self.isReloading = false
            })
            
        }else {
            // リロードできない
            print("reloadButtonTapped リロードできない")
        }
    }
    
    func changeWeaponButtonTapped() {
        print("Presenter changeWeaponButtonTapped")
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
