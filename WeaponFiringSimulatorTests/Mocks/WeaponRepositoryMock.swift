//
//  WeaponRepositoryMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 9/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class WeaponRepositoryMock: WeaponRepositoryInterface {
    var weapons: [Weapon] = [
        .init(
            id: 0,
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
    
    func get(by id: Int) throws -> Weapon {
        guard let weapon = weapons.first(where: { $0.id == id }) else {
            throw CustomError.other(message: "武器が存在しません id: \(id)")
        }
        return weapon
    }
    
    func getAll() -> [Weapon] {
        return weapons
    }
}
