//
//  WeaponResourceGetUseCaseMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 14/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class WeaponResourceGetUseCaseMock: WeaponResourceGetUseCaseInterface {
    var weaponListItems: [WeaponListItem] = [
        .init(weaponId: 100, weaponImageName: "weaponImageName100"),
        .init(weaponId: 101, weaponImageName: "weaponImageName101"),
        .init(weaponId: 102, weaponImageName: "weaponImageName102")
    ]
    
    var defaultWeaponDetail = CurrentWeaponData(
        id: 100,
        weaponImageName: "mock_weaponImageName",
        bulletsCountImageBaseName: "mock_bulletsCountImageBaseName",
        capacity: 100,
        // MEMO: リロード待ち時間はテスト時も実際に待機されるので大き過ぎない値にしている
        reloadWaitingTime: 0.5,
        reloadType: .manual,
        showingSound: .pistolSet,
        firingSound: .pistolShoot,
        reloadingSound: .pistolReload,
        noBulletsSound: .pistolOutBullets,
        bulletsCount: 100,
        isReloading: false
    )

    func getWeaponListItems() -> [WeaponFiringSimulator.WeaponListItem] {
        return weaponListItems
    }
    
    func getDefaultWeaponDetail() throws -> WeaponFiringSimulator.CurrentWeaponData {
        return defaultWeaponDetail
    }
    
    func getWeaponDetail(of weaponId: Int) throws -> WeaponFiringSimulator.CurrentWeaponData {
        return CurrentWeaponData(
            id: weaponId,
            weaponImageName: "mock_weaponImageName\(weaponId)",
            bulletsCountImageBaseName: "mock_bulletsCountImageBaseName\(weaponId)",
            capacity: 100,
            // MEMO: リロード待ち時間はテスト時も実際に待機されるので大き過ぎない値にしている
            reloadWaitingTime: 0.5,
            reloadType: .manual,
            showingSound: .pistolSet,
            firingSound: .pistolShoot,
            reloadingSound: .pistolReload,
            noBulletsSound: .pistolOutBullets,
            bulletsCount: 100,
            isReloading: false
        )
    }
}
