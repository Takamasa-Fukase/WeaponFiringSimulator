//
//  DomainLayer.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

class DomainLayer {
    func canFire(
        type: WeaponType,
        bulletsCount: Int,
        isReloading: Bool
    ) -> Bool {
        print("DomainLayer canFire type: \(type), bulletsCount: \(bulletsCount), isReloading: \(isReloading)")
        if isReloading { return false }
        print("canFire 0")
        if bulletsCount > 0 {
            print("canFire return true")
            return true
        }else {
            print("canFire return flase")
            return false
        }
    }
    
    func canReload(
        type: WeaponType,
        bulletsCount: Int,
        isReloading: Bool
    ) -> Bool {
        print("DomainLayer canReload type: \(type), bulletsCount: \(bulletsCount), isReloading: \(isReloading)")
        if isReloading { return false }
        print("canReload 0")

        if bulletsCount <= 0 {
            print("canReload return true")
            return true
        }else {
            print("canReload return true")
            return false
        }
    }
}
