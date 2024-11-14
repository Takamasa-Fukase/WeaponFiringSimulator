//
//  WeaponFireUseCaseTests.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 8/11/24.
//

import XCTest
@testable import WeaponFiringSimulator

//final class WeaponFireUseCaseTests: XCTestCase {
//    private var weaponRepositoryMock: WeaponRepositoryMock!
//    private var canFireCheckUseCaseMock: CanFireCheckUseCaseMock!
//    private var needsAutoReloadCheckUseCaseMock: NeedsAutoReloadCheckUseCaseMock!
//    private var weaponFireUseCase: WeaponFireUseCase!
//    
//    override func setUpWithError() throws {
//        weaponRepositoryMock = WeaponRepositoryMock()
//        canFireCheckUseCaseMock = CanFireCheckUseCaseMock()
//        needsAutoReloadCheckUseCaseMock = NeedsAutoReloadCheckUseCaseMock()
//        weaponFireUseCase = WeaponFireUseCase(
//            weaponRepository: weaponRepositoryMock,
//            canFireCheckUseCase: canFireCheckUseCaseMock,
//            needsAutoReloadCheckUseCase: needsAutoReloadCheckUseCaseMock
//        )
//    }
//    
//    override func tearDownWithError() throws {
//        weaponRepositoryMock = nil
//        canFireCheckUseCaseMock = nil
//        needsAutoReloadCheckUseCaseMock = nil
//        weaponFireUseCase = nil
//    }
//    
//    func test_execute_onFireが呼ばれてneedsAutoReloadには設定した値と同じ値が返ってきてonCanceledが呼ばれなければ成功() throws {
//        // 発射できる様にする
//        canFireCheckUseCaseMock.canFire = true
//        
//        // 自動リロードしないようにする
//        needsAutoReloadCheckUseCaseMock.needsAutoReload = false
//        
//        let request1 = WeaponFireRequest(
//            weaponId: 0,
//            bulletsCount: 0,
//            isReloading: false
//        )
//        try weaponFireUseCase.execute(
//            request: request1,
//            onFired: { response in
//                XCTAssertEqual(response.needsAutoReload, false)
//            },
//            onCanceled: { _ in
//                XCTFail()
//            })
//        
//        // 自動リロードするようにする
//        needsAutoReloadCheckUseCaseMock.needsAutoReload = true
//        
//        let request2 = WeaponFireRequest(
//            weaponId: 0,
//            bulletsCount: 0,
//            isReloading: false
//        )
//        try weaponFireUseCase.execute(
//            request: request2,
//            onFired: { response in
//                XCTAssertEqual(response.needsAutoReload, true)
//            },
//            onCanceled: { _ in
//                XCTFail()
//            })
//    }
//    
//    func test_execute_onFireが呼ばれずにonCanceledが呼ばれたら成功() throws {
//        // 発射できない様にする
//        canFireCheckUseCaseMock.canFire = false
//        
//        var isOnCanceledCalled = false
//        
//        let request = WeaponFireRequest(
//            weaponId: 0,
//            bulletsCount: 0,
//            isReloading: false
//        )
//        try weaponFireUseCase.execute(
//            request: request,
//            onFired: { _ in
//                XCTFail()
//            },
//            onCanceled: { _ in
//                isOnCanceledCalled = true
//            })
//        
//        XCTAssertEqual(isOnCanceledCalled, true)
//    }
//    
//    func test_execute_WeaponFireCompletedResponseの内容がrequestに対して期待した値で返ってくれば成功() throws {
//        // 手動リロードのテスト用の武器を追加
//        let testManualReloadWeapon = Weapon(
//            id: 100,
//            weaponImageName: "testManualReloadWeaponImage",
//            bulletsCountImageBaseName: "testManualReloadWeaponBulletsCountImage",
//            capacity: 100,
//            reloadWaitingTime: 100,
//            reloadType: .manual,
//            showingSound: .pistolSet,
//            firingSound: .pistolShoot,
//            reloadingSound: .pistolReload,
//            noBulletsSound: .pistolOutBullets
//        )
//        weaponRepositoryMock.weapons.append(testManualReloadWeapon)
//        // 撃てる様にする
//        canFireCheckUseCaseMock.canFire = true
//        // 自動リロードしない様にする
//        needsAutoReloadCheckUseCaseMock.needsAutoReload = false
//        
//        let testManualReloadWeaponFireRequest = WeaponFireRequest(
//            weaponId: 100,
//            bulletsCount: 100,
//            isReloading: false
//        )
//        try weaponFireUseCase.execute(
//            request: testManualReloadWeaponFireRequest,
//            onFired: { response in
//                let expectedResponse = WeaponFireCompletedResponse(
//                    firingSound: .pistolShoot,
//                    bulletsCountImageName: "testManualReloadWeaponBulletsCountImage99",
//                    bulletsCount: 99,
//                    needsAutoReload: false
//                )
//                XCTAssertEqual(response.firingSound, expectedResponse.firingSound)
//                XCTAssertEqual(response.bulletsCountImageName, expectedResponse.bulletsCountImageName)
//                XCTAssertEqual(response.bulletsCount, expectedResponse.bulletsCount)
//                XCTAssertEqual(response.needsAutoReload, expectedResponse.needsAutoReload)
//
//            }, onCanceled: { _ in
//                XCTFail()
//            })
//        
//        // 自動リロードのテスト用の武器を追加
//        let testAutoReloadWeapon = Weapon(
//            id: 101,
//            weaponImageName: "testAutoReloadWeaponImage",
//            bulletsCountImageBaseName: "testAutoReloadWeaponBulletsCountImage",
//            capacity: 100,
//            reloadWaitingTime: 100,
//            reloadType: .auto,
//            showingSound: .bazookaSet,
//            firingSound: .bazookaShoot,
//            reloadingSound: .bazookaReload,
//            noBulletsSound: nil
//        )
//        weaponRepositoryMock.weapons.append(testAutoReloadWeapon)
//        // 自動リロードする様にする
//        needsAutoReloadCheckUseCaseMock.needsAutoReload = true
//        
//        let testAutoReloadWeaponFireRequest = WeaponFireRequest(
//            weaponId: 101,
//            bulletsCount: 100,
//            isReloading: false
//        )
//        try weaponFireUseCase.execute(
//            request: testAutoReloadWeaponFireRequest,
//            onFired: { response in
//                let expectedResponse = WeaponFireCompletedResponse(
//                    firingSound: .bazookaShoot,
//                    bulletsCountImageName: "testAutoReloadWeaponBulletsCountImage99",
//                    bulletsCount: 99,
//                    needsAutoReload: true
//                )
//                XCTAssertEqual(response.firingSound, expectedResponse.firingSound)
//                XCTAssertEqual(response.bulletsCountImageName, expectedResponse.bulletsCountImageName)
//                XCTAssertEqual(response.bulletsCount, expectedResponse.bulletsCount)
//                XCTAssertEqual(response.needsAutoReload, expectedResponse.needsAutoReload)
//
//            }, onCanceled: { _ in
//                XCTFail()
//            })
//    }
//}
