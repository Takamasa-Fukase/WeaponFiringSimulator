//
//  WeaponChangeUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

class WeaponChangeUseCase {
    func execute(
        weapon: Weapon,
        onCompleted: ((_ newWeapon: Weapon) -> Void)
    ) {
        let newWeaponType: WeaponType = {
            switch weapon.type {
            case .pistol:
                return .bazooka
            case .bazooka:
                return .pistol
            }
        }()
        let imageName: String = {
            switch newWeaponType {
            case .pistol:
                return "pistol"
            case .bazooka:
                return "bazooka"
            }
        }()
        let capacity: Int = {
            switch newWeaponType {
            case .pistol:
                return 7
            case .bazooka:
                return 1
            }
        }()
        let reloadWaitingTime: TimeInterval = {
            switch newWeaponType {
            case .pistol:
                return 0
            case .bazooka:
                return 3.2
            }
        }()
        let reloadType: ReloadType = {
            switch newWeaponType {
            case .pistol:
                return .manual
            case .bazooka:
                return .auto
            }
        }()
        let newWeapon = Weapon(
            type: newWeaponType,
            imageName: imageName,
            capacity: capacity,
            reloadWaitingTime: reloadWaitingTime,
            bulletsCount: capacity,
            isReloading: false,
            reloadType: reloadType
        )
        onCompleted(newWeapon)
    }
}
