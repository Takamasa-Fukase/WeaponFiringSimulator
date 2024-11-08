//
//  WeaponFireUseCaseTests.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 8/11/24.
//

import XCTest
@testable import WeaponFiringSimulator

final class WeaponFireUseCaseTests: XCTestCase {
    private var weaponRepository: WeaponRepositoryInterface!
    private var canFireCheckUseCaseMock: CanFireCheckUseCaseMock!
    private var needsAutoReloadCheckUseCaseMock: NeedsAutoReloadCheckUseCaseMock!
    private var weaponFireUseCase: WeaponFireUseCase!
    
    override func setUpWithError() throws {
        weaponRepository = WeaponRepository()
        canFireCheckUseCaseMock = CanFireCheckUseCaseMock()
        needsAutoReloadCheckUseCaseMock = NeedsAutoReloadCheckUseCaseMock()
        weaponFireUseCase = WeaponFireUseCase(
            weaponRepository: weaponRepository,
            canFireCheckUseCase: canFireCheckUseCaseMock,
            needsAutoReloadCheckUseCase: needsAutoReloadCheckUseCaseMock
        )
    }
    
    override func tearDownWithError() throws {
        weaponRepository = nil
        canFireCheckUseCaseMock = nil
        needsAutoReloadCheckUseCaseMock = nil
        weaponFireUseCase = nil
    }
    
    func test_execute_onFireが呼ばれてneedsAutoReloadには設定した値と同じ値が返ってきてonCanceledが呼ばれなければ成功() throws {
        // 発射できる様にする
        canFireCheckUseCaseMock.canFire = true
        
        // 自動リロードしないようにする
        needsAutoReloadCheckUseCaseMock.needsAutoReload = false
        
        let request1 = WeaponFireRequest(
            weaponType: .pistol,
            bulletsCount: 0,
            isReloading: false
        )
        try weaponFireUseCase.execute(
            request: request1,
            onFired: { response in
                XCTAssertEqual(response.needsAutoReload, false)
            },
            onCanceled: { response in
                XCTFail()
            })
        
        // 自動リロードするようにする
        needsAutoReloadCheckUseCaseMock.needsAutoReload = true
        
        let request2 = WeaponFireRequest(
            weaponType: .pistol,
            bulletsCount: 0,
            isReloading: false
        )
        try weaponFireUseCase.execute(
            request: request2,
            onFired: { response in
                XCTAssertEqual(response.needsAutoReload, true)
            },
            onCanceled: { response in
                XCTFail()
            })
    }
}
