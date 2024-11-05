//
//  Weapon.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

enum WeaponType {
    case pistol
    case bazooka
}

enum ReloadType {
    case manual
    case auto
}

struct Weapon {
    let type: WeaponType
    let imageName: String
    let capacity: Int
    let reloadWaitingTime: TimeInterval
    let bulletsCount: Int
    let isReloading: Bool
    let reloadType: ReloadType
    
    func canFire(
        bulletsCount: Int,
        isReloading: Bool
    ) -> Bool {
        print("Weapon canFire bulletsCount: \(bulletsCount), isReloading: \(isReloading)")
        if isReloading { return false }
        if bulletsCount > 0 {
            print("canFire return true")
            return true
        }else {
            print("canFire return flase")
            return false
        }
    }
    
    func canReload(
        bulletsCount: Int,
        isReloading: Bool
    ) -> Bool {
        print("Weapon canReload bulletsCount: \(bulletsCount), isReloading: \(isReloading)")
        if isReloading { return false }
        if bulletsCount <= 0 {
            print("canReload return true")
            return true
        }else {
            print("canReload return false")
            return false
        }
    }
    
    func needsAutoReload(
        bulletsCount: Int,
        isReloading: Bool,
        reloadType: ReloadType
    ) -> Bool {
        print("Weapon needsAutoReload bulletsCount: \(bulletsCount), isReloading: \(isReloading), reloadType: \(reloadType)")
        if isReloading { return false }
        if bulletsCount == 0 && reloadType == .auto {
            print("needsAutoReload return true")
            return true
        }else {
            print("needsAutoReload return false")
            return false
        }
    }
}
