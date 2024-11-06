//
//  InitialWeaponGetUseCaseMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 6/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class InitialWeaponGetUseCaseMock: InitialWeaponGetUseCaseInterface {
    func execute(onCompleted: ((WeaponFiringSimulator.InitialWeaponGetResponse) -> Void)) throws {
        let weapon: Weapon = .init(
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
        )
        let response = InitialWeaponGetResponse(
            weaponType: weapon.type,
            weaponImageName: weapon.weaponImageName,
            bulletsCountImageBaseName: weapon.bulletsCountImageBaseName,
            bulletsCount: weapon.capacity,
            isReloading: false,
            showingSound: weapon.showingSound
        )
        onCompleted(response)
    }
}
