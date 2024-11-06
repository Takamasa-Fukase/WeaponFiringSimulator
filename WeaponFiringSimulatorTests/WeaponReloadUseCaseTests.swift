//
//  WeaponReloadUseCaseTests.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 6/11/24.
//

import XCTest
@testable import WeaponFiringSimulator

final class WeaponReloadUseCaseTests: XCTestCase {
    private var weaponRepository: WeaponRepositoryInterface!
    private var weaponReloadUseCase: WeaponReloadUseCase!
    
    override func setUpWithError() throws {
        weaponRepository = WeaponRepository()
        weaponReloadUseCase = WeaponReloadUseCase(weaponRepository: weaponRepository)
    }
    
    override func tearDownWithError() throws {
        weaponRepository = nil
        weaponReloadUseCase = nil
    }
    
    func test_execute_リロード完了までかかった経過時間と本来のピストルのリロード待ち時間との差分が０．５秒以内なら成功() throws {
        let expectation = expectation(description: "test_execute")
        
        let request = WeaponReloadRequest(
            weaponType: .pistol,
            bulletsCount: 0,
            isReloading: false
        )
        
        let startTime = Date()
        let pistolReloadWaitTime = 0.0
        
        try weaponReloadUseCase.execute(
            request: request,
            onReloadStarted: { response in
                
            },
            onReloadEnded: { response in
                let elapsedTime = Date().timeIntervalSince(startTime)
                let diff = abs(elapsedTime - pistolReloadWaitTime)
                print("onReloadEnded elapsedTime: \(elapsedTime), diff: \(diff)")

                XCTAssertEqual((diff < 0.5), true)
                
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 5)
    }
    
    func test_execute_リロード完了までかかった経過時間と本来のバズーカのリロード待ち時間との差分が０．５秒以内なら成功() throws {
        let expectation = expectation(description: "test_execute")
        
        let request = WeaponReloadRequest(
            weaponType: .bazooka,
            bulletsCount: 0,
            isReloading: false
        )
        
        let startTime = Date()
        let bazookaReloadWaitTime = 3.2
        
        try weaponReloadUseCase.execute(
            request: request,
            onReloadStarted: { response in
                
            },
            onReloadEnded: { response in
                let elapsedTime = Date().timeIntervalSince(startTime)
                let diff = abs(elapsedTime - bazookaReloadWaitTime)
                print("onReloadEnded elapsedTime: \(elapsedTime), diff: \(diff)")

                XCTAssertEqual((diff < 0.5), true)
                
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 5)
    }
}