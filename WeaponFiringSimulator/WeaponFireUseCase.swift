//
//  WeaponFireUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

class WeaponFireUseCase {
    func execute(
        weapon: Weapon,
        onFired: ((_ firedWeapon: Weapon, _ needsAutoReload: Bool) -> Void),
        onCanceled: (() -> Void)
    ) {
        if weapon.canFire(
            bulletsCount: weapon.bulletsCount,
            isReloading: weapon.isReloading
        ) {
            let firedWeapon = Weapon(
                type: weapon.type,
                imageName: weapon.imageName,
                capacity: weapon.capacity,
                reloadWaitingTime: weapon.reloadWaitingTime,
                // 弾数をマイナス1する
                bulletsCount: weapon.bulletsCount - 1,
                isReloading: weapon.isReloading,
                reloadType: weapon.reloadType
            )
            let needsAutoReload = firedWeapon.needsAutoReload(
                bulletsCount: weapon.bulletsCount,
                isReloading: weapon.isReloading,
                reloadType: weapon.reloadType
            )
            onFired(firedWeapon, needsAutoReload)
            
        }else {
            onCanceled()
        }
    }
}
