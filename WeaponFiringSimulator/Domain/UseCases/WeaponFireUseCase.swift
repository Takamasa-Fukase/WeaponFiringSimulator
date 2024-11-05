//
//  WeaponFireUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

class WeaponFireUseCase {
    func execute(
        weapon: AnyWeaponType,
        onFired: ((_ firedWeapon: AnyWeaponType, _ needsAutoReload: Bool) -> Void),
        onCanceled: (() -> Void)
    ) {
        if weapon.canFire(
            bulletsCount: weapon.bulletsCount,
            isReloading: weapon.isReloading
        ) {
            let firedWeapon = weapon.copyWith(
                // 弾数をマイナス1する
                bulletsCount: weapon.bulletsCount - 1,
                isReloading: weapon.isReloading
            )
            let needsAutoReload = firedWeapon.needsAutoReload(
                bulletsCount: firedWeapon.bulletsCount,
                isReloading: firedWeapon.isReloading,
                reloadType: firedWeapon.reloadType
            )
            onFired(firedWeapon, needsAutoReload)
            
        }else {
            onCanceled()
        }
    }
}
