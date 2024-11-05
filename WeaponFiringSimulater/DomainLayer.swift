//
//  DomainLayer.swift
//  WeaponFiringSimulater
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
        if isReloading { return false }
        
        if bulletsCount > 0 {
            return true
        }else {
            return false
        }
    }
    
    func canReload(
        type: WeaponType,
        bulletsCount: Int,
        isReloading: Bool
    ) -> Bool {
        if isReloading { return false }
        
        if bulletsCount <= 0 {
            return true
        }else {
            return false
        }
    }
}
