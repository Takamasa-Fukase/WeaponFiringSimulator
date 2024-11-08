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
    private var canReloadCheckUseCaseMock: CanReloadCheckUseCaseMock!
    private var weaponReloadUseCase: WeaponReloadUseCase!
    
    override func setUpWithError() throws {
        weaponRepository = WeaponRepository()
        canReloadCheckUseCaseMock = CanReloadCheckUseCaseMock()
        weaponReloadUseCase = WeaponReloadUseCase(
            weaponRepository: weaponRepository,
            canReloadCheckUseCase: canReloadCheckUseCaseMock
        )
    }
    
    override func tearDownWithError() throws {
        weaponRepository = nil
        canReloadCheckUseCaseMock = nil
        weaponReloadUseCase = nil
    }
    
    func test_execute_リロード開始から終了までかかった経過時間と本来のピストルのリロード待ち時間との差分が０．５秒以内なら成功() throws {
        let expectation = expectation(description: "test_execute")
        
        // リロードできる様にする
        canReloadCheckUseCaseMock.canReload = true
        
        let request = WeaponReloadRequest(
            weaponType: .pistol,
            bulletsCount: 0,
            isReloading: false
        )
        
        var startTime: Date?
        let pistolReloadWaitTime = 0.0
        
        try weaponReloadUseCase.execute(
            request: request,
            onReloadStarted: { _ in
                startTime = Date()
            },
            onReloadEnded: { _ in
                let elapsedTime = Date().timeIntervalSince(startTime ?? Date())
                let diff = abs(elapsedTime - pistolReloadWaitTime)
                print("onReloadEnded elapsedTime: \(elapsedTime), diff: \(diff)")

                XCTAssertEqual((diff < 0.5), true)
                
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 5)
    }
    
    func test_execute_リロード開始から終了までかかった経過時間と本来のバズーカのリロード待ち時間との差分が０．５秒以内なら成功() throws {
        let expectation = expectation(description: "test_execute")
        
        // リロードできる様にする
        canReloadCheckUseCaseMock.canReload = true
        
        let request = WeaponReloadRequest(
            weaponType: .bazooka,
            bulletsCount: 0,
            isReloading: false
        )
        
        var startTime: Date?
        let bazookaReloadWaitTime = 3.2
        
        try weaponReloadUseCase.execute(
            request: request,
            onReloadStarted: { _ in
                startTime = Date()
            },
            onReloadEnded: { _ in
                let elapsedTime = Date().timeIntervalSince(startTime ?? Date())
                let diff = abs(elapsedTime - bazookaReloadWaitTime)
                print("onReloadEnded elapsedTime: \(elapsedTime), diff: \(diff)")

                XCTAssertEqual((diff < 0.5), true)
                
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 5)
    }
    
    
    func test_execute_リロード開始もリロード終了も呼ばれなければ成功() throws {
        let expectation = expectation(description: "test_execute")
        
        // リロードできない様にする
        canReloadCheckUseCaseMock.canReload = false
        
        let pistolReloadRequest = WeaponReloadRequest(
            // ピストルのリロードをリクエスト
            weaponType: .pistol,
            bulletsCount: 0,
            isReloading: false
        )
        try weaponReloadUseCase.execute(
            request: pistolReloadRequest,
            onReloadStarted: { _ in
                XCTFail()
            },
            onReloadEnded: { _ in
                XCTFail()
            })
        
        let bazookaReloadRequest = WeaponReloadRequest(
            // バズーカのリロードをリクエスト
            weaponType: .bazooka,
            bulletsCount: 0,
            isReloading: false
        )
        try weaponReloadUseCase.execute(
            request: bazookaReloadRequest,
            onReloadStarted: { _ in
                XCTFail()
            },
            onReloadEnded: { _ in
                XCTFail()
            })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5, execute: {
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 5)
    }
}
