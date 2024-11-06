//
//  PresenterTests.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 6/11/24.
//

import XCTest
@testable import WeaponFiringSimulator

final class PresenterTests: XCTestCase {
    private var presenter: Presenter!
    private var vcMock: ViewControllerMock!
    private var initialWeaponGetUseCaseMock: InitialWeaponGetUseCaseMock!
    private var weaponFireUseCaseMock: WeaponFireUseCaseMock!
    private var weaponReloadUseCaseMock: WeaponReloadUseCaseMock!
    private var weaponChangeUseCaseMock: WeaponChangeUseCaseMock!
    
    override func setUpWithError() throws {
        vcMock = ViewControllerMock()
        initialWeaponGetUseCaseMock = InitialWeaponGetUseCaseMock()
        weaponFireUseCaseMock = WeaponFireUseCaseMock()
        weaponReloadUseCaseMock = WeaponReloadUseCaseMock()
        weaponChangeUseCaseMock = WeaponChangeUseCaseMock()
        presenter = .init(view: vcMock,
                          initialWeaponGetUseCase: initialWeaponGetUseCaseMock,
                          weaponFireUseCase: weaponFireUseCaseMock,
                          weaponReloadUseCase: weaponReloadUseCaseMock,
                          weaponChangeUseCase: weaponChangeUseCaseMock)
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        vcMock = nil
        initialWeaponGetUseCaseMock = nil
        weaponFireUseCaseMock = nil
        weaponReloadUseCaseMock = nil
        weaponChangeUseCaseMock = nil
    }
    
    func test_viewDidLoad() throws {
        XCTAssertEqual(false, vcMock.updateWeaponTypeCalled)
        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.updateReloadingFlagCalled)

        presenter.viewDidLoad()

        XCTAssertEqual(true, vcMock.updateWeaponTypeCalled)
        XCTAssertEqual(true, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(true, vcMock.updateReloadingFlagCalled)
    }
}
