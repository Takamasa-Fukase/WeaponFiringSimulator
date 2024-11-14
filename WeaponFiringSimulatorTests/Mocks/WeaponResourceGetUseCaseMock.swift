//
//  WeaponResourceGetUseCaseMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 14/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class WeaponResourceGetUseCaseMock: WeaponResourceGetUseCaseInterface {
    var getWeaponListItemsCalledCount: Int = 0
    var getDefaultWeaponDetailCalledCount: Int = 0
    var getWeaponDetailCalledValues = [Int]()
    
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
    
    var weaponDetail = CurrentWeaponData(
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
        getWeaponListItemsCalledCount += 1
        return weaponListItems
    }
    
    func getDefaultWeaponDetail() throws -> WeaponFiringSimulator.CurrentWeaponData {
        getDefaultWeaponDetailCalledCount += 1
        return defaultWeaponDetail
    }
    
    func getWeaponDetail(of weaponId: Int) throws -> WeaponFiringSimulator.CurrentWeaponData {
        getWeaponDetailCalledValues.append(weaponId)
        return weaponDetail
    }
}
