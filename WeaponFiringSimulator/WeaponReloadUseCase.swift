//
//  WeaponReloadUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

class WeaponReloadUseCase {
    func execute(
        weapon: Weapon,
        onReloadStarted: ((_ reloadingWeapon: Weapon) -> Void),
        onReloadEnded: @escaping ((_ reloadedWeapon: Weapon) -> Void)
    ) {
        if weapon.canReload(
            bulletsCount: weapon.bulletsCount,
            isReloading: weapon.isReloading
        ) {
            let reloadingWeapon = Weapon(
                type: weapon.type,
                imageName: weapon.imageName,
                capacity: weapon.capacity,
                reloadWaitingTime: weapon.reloadWaitingTime,
                bulletsCount: weapon.bulletsCount,
                // リロード中をtrueにする
                isReloading: true,
                reloadType: weapon.reloadType
            )
            onReloadStarted(reloadingWeapon)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + weapon.reloadWaitingTime, execute: {
                let reloadedWeapon = Weapon(
                    type: weapon.type,
                    imageName: weapon.imageName,
                    capacity: weapon.capacity,
                    reloadWaitingTime: weapon.reloadWaitingTime,
                    // 残弾数をその武器の装弾数（MAX）にする
                    bulletsCount: weapon.capacity,
                    // リロード中をfalseにする
                    isReloading: true,
                    reloadType: weapon.reloadType
                )
                onReloadEnded(reloadedWeapon)
            })
        }
    }
}
