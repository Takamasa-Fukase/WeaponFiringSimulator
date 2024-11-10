//
//  WeaponListGetUseCaseTests.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 9/11/24.
//

import XCTest
@testable import WeaponFiringSimulator

final class WeaponListGetUseCaseTests: XCTestCase {
    private var weaponRepository: WeaponRepositoryMock!
    private var weaponListGetUseCase: WeaponListGetUseCase!

    override func setUpWithError() throws {
        weaponRepository = WeaponRepositoryMock()
        weaponListGetUseCase = WeaponListGetUseCase(weaponRepository: weaponRepository)
    }

    override func tearDownWithError() throws {
        weaponRepository = nil
        weaponListGetUseCase = nil
    }
    
    func test_execute() {
        weaponRepository.weapons = [
            .init(id: 0, weaponImageName: "weapon0", bulletsCountImageBaseName: "", capacity: 0, reloadWaitingTime: 0, reloadType: .manual, showingSound: .pistolSet, firingSound: .pistolShoot, reloadingSound: .pistolReload, noBulletsSound: .pistolOutBullets),
            .init(id: 1, weaponImageName: "weapon1", bulletsCountImageBaseName: "", capacity: 0, reloadWaitingTime: 0, reloadType: .manual, showingSound: .pistolSet, firingSound: .pistolShoot, reloadingSound: .pistolReload, noBulletsSound: .pistolOutBullets),
            .init(id: 2, weaponImageName: "weapon2", bulletsCountImageBaseName: "", capacity: 0, reloadWaitingTime: 0, reloadType: .manual, showingSound: .pistolSet, firingSound: .pistolShoot, reloadingSound: .pistolReload, noBulletsSound: .pistolOutBullets),
            .init(id: 3, weaponImageName: "weapon3", bulletsCountImageBaseName: "", capacity: 0, reloadWaitingTime: 0, reloadType: .manual, showingSound: .pistolSet, firingSound: .pistolShoot, reloadingSound: .pistolReload, noBulletsSound: .pistolOutBullets)
        ]
        
        let expectedItems: [WeaponListItem] = [
            .init(weaponId: 0, weaponImageName: "weapon0"),
            .init(weaponId: 1, weaponImageName: "weapon1"),
            .init(weaponId: 2, weaponImageName: "weapon2"),
            .init(weaponId: 3, weaponImageName: "weapon3")
        ]
        
        let items = weaponListGetUseCase.execute().weaponListItems
        
        XCTAssertEqual(items, expectedItems)
    }
}
