//
//  WeaponRepository.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 6/11/24.
//

import Foundation

final class WeaponRepository: WeaponRepositoryInterface {
    private let weapons: [Weapon] = [
        .init(
            type: .pistol,
            weaponImageName: "pistol",
            bulletsCountImageBaseName: "bullets",
            capacity: 7,
            reloadWaitingTime: 0,
            reloadType: .manual,
            showingSound: .pistolSet,
            firingSound: .pistolShoot,
            reloadingSound: .pistolReload,
            noBulletsSound: .pistolOutBullets
        ),
        .init(
            type: .bazooka,
            weaponImageName: "bazooka",
            bulletsCountImageBaseName: "bazookaRocket",
            capacity: 1,
            reloadWaitingTime: 3.2,
            reloadType: .auto,
            showingSound: .bazookaSet,
            firingSound: .bazookaShoot,
            reloadingSound: .bazookaReload,
            noBulletsSound: nil
        )
    ]
    
    func get(by type: WeaponType) throws -> Weapon {
        guard let weapon = weapons.first(where: { $0.type == type }) else {
            //　エラーをthrowする
            throw CustomError.other(message: "武器が存在しません type: \(type)")
        }
        return weapon
    }
    
    func getList() -> [Weapon] {
        return weapons
    }
}
