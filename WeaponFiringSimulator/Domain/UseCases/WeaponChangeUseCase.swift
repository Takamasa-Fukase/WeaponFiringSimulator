//
//  WeaponChangeUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

class WeaponChangeUseCase {
    func execute(
        weapon: AnyWeaponType,
        onCompleted: ((_ newWeapon: AnyWeaponType) -> Void)
    ) {
        let newWeapon: AnyWeaponType = {
            if weapon is Pistol {
                return Bazooka(bulletsCount: 1, isReloading: false)
            }else {
                return Pistol(bulletsCount: 7, isReloading: false)
            }
        }()
        onCompleted(newWeapon)
    }
}
