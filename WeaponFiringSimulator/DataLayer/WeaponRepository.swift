//
//  WeaponRepository.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 6/11/24.
//

import Foundation
import Domain

public final class WeaponRepository: WeaponRepositoryInterface {
    public init() {}
    
    private let weapons: [Weapon] = [
        .init(
            id: 0,
            isDefault: true,
            weaponImageName: "pistol",
            bulletsCountImageBaseName: "pistol_bullets_",
            capacity: 7,
            reloadWaitingTime: 0,
            reloadType: .manual,
            showingSound: .pistolSet,
            firingSound: .pistolShoot,
            reloadingSound: .pistolReload,
            noBulletsSound: .pistolOutBullets
        ),
        .init(
            id: 1,
            isDefault: false,
            weaponImageName: "bazooka",
            bulletsCountImageBaseName: "bazooka_bullets_",
            capacity: 1,
            reloadWaitingTime: 3.2,
            reloadType: .auto,
            showingSound: .bazookaSet,
            firingSound: .bazookaShoot,
            reloadingSound: .bazookaReload,
            noBulletsSound: nil
        )
    ]
    
    public func get(by id: Int) throws -> Weapon {
        guard let weapon = weapons.first(where: { $0.id == id }) else {
            //　エラーをthrowする
            throw CustomError.other(message: "武器が存在しません id: \(id)")
        }
        return weapon
    }
    
    public func getDefault() throws -> Weapon {
        guard let weapon = weapons.first(where: { $0.isDefault }) else {
            //　エラーをthrowする
            throw CustomError.other(message: "デフォルトの武器が存在しません")
        }
        return weapon
    }
    
    public func getAll() -> [Weapon] {
        return weapons
    }
}
