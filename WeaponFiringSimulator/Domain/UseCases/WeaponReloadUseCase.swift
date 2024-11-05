//
//  WeaponReloadUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

class WeaponReloadUseCase {
    func execute(
        weapon: AnyWeaponType,
        onReloadStarted: ((_ reloadingWeapon: AnyWeaponType) -> Void),
        onReloadEnded: @escaping ((_ reloadedWeapon: AnyWeaponType) -> Void)
    ) {
        if weapon.canReload(
            bulletsCount: weapon.bulletsCount,
            isReloading: weapon.isReloading
        ) {
            let reloadingWeapon = weapon.copyWith(
                bulletsCount: weapon.bulletsCount,
                // リロード中をtrueにする
                isReloading: true
            )
            onReloadStarted(reloadingWeapon)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + weapon.reloadWaitingTime, execute: {
                let reloadedWeapon = weapon.copyWith(
                    // 残弾数をその武器の装弾数（MAX）にする
                    bulletsCount: weapon.capacity,
                    // リロード中をtrueにする
                    isReloading: false
                )
                onReloadEnded(reloadedWeapon)
            })
        }
    }
}
