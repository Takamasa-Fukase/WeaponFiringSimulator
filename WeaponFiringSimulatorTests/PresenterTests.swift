//
//  PresenterTests.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 13/11/24.
//

import XCTest
@testable import WeaponFiringSimulator

final class PresenterTests: XCTestCase {
    private var presenter: Presenter!
    private var vcMock: ViewControllerMock!
    private var weaponResourceGetUseCaseMock: WeaponResourceGetUseCaseMock!
    private var weaponActionExecuteUseCase: WeaponActionExecuteUseCase!
//    private let weaponRepositoryMock: WeaponRepositoryMock!
    
    override func setUpWithError() throws {
        vcMock = ViewControllerMock()
//        weaponRepositoryMock = .init()
        weaponResourceGetUseCaseMock = WeaponResourceGetUseCaseMock()
        weaponActionExecuteUseCase = .init(weaponStatusCheckUseCase: WeaponStatusCheckUseCase())
    }
    
    override func tearDownWithError() throws {
        vcMock = nil
        weaponResourceGetUseCaseMock = nil
        weaponActionExecuteUseCase = nil
//        weaponRepositoryMock = nil
    }
    
    /*
     期待すること
     - 取得する武器が、Repositoryがデフォルトの武器として返却するものと同じこと
     - 取得した武器の値でshowWeaponImage()が呼ばれること
     - 取得した武器の値でshowBulletsCountImage()が呼ばれること
     - 取得した武器の値でplayShowingSound()が呼ばれること
     */
    func test_viewDidLoad() throws {
        XCTAssertEqual(vcMock.showWeaponImageCalledValues, [])
        XCTAssertEqual(vcMock.showBulletsCountImageCalledValues, [])
        XCTAssertEqual(vcMock.playShowingSoundCalledValues, [])
        
        presenter.viewDidLoad()
        
        XCTAssertEqual(vcMock.showWeaponImageCalledValues, [weaponResourceGetUseCaseMock.defaultWeaponDetail.weaponImageName])
        XCTAssertEqual(vcMock.showBulletsCountImageCalledValues, [weaponResourceGetUseCaseMock.defaultWeaponDetail.bulletsCountImageName()])
        XCTAssertEqual(vcMock.playShowingSoundCalledValues, [weaponResourceGetUseCaseMock.defaultWeaponDetail.showingSound])
    }
}
