//
//  DomainLayer.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

enum WeaponType {
    case pistol
    case bazooka
    
    var capacity: Int {
        switch self {
        case .pistol:
            return 7
        case .bazooka:
            return 1
        }
    }
    
    var reloadWaitingTime: TimeInterval {
        switch self {
        case .pistol:
            return 0
        case .bazooka:
            return 3.2
        }
    }
}

class DomainLayer {
    func canFire(
        type: WeaponType,
        bulletsCount: Int,
        isReloading: Bool
    ) -> Bool {
        print("DomainLayer canFire type: \(type), bulletsCount: \(bulletsCount), isReloading: \(isReloading)")
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
        type: WeaponType,
        bulletsCount: Int,
        isReloading: Bool
    ) -> Bool {
        print("DomainLayer canReload type: \(type), bulletsCount: \(bulletsCount), isReloading: \(isReloading)")
        if isReloading { return false }
        if bulletsCount <= 0 {
            print("canReload return true")
            return true
        }else {
            print("canReload return true")
            return false
        }
    }
}
