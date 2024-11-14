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
    
    override func setUpWithError() throws {
        vcMock = ViewControllerMock()
        weaponResourceGetUseCaseMock = .init()
        weaponActionExecuteUseCase = .init(weaponStatusCheckUseCase: WeaponStatusCheckUseCase())
        presenter = .init(view: vcMock,
                          weaponResourceGetUseCase: weaponResourceGetUseCaseMock,
                          weaponActionExecuteUseCase: weaponActionExecuteUseCase)
    }
    
    override func tearDownWithError() throws {
        vcMock = nil
        weaponResourceGetUseCaseMock = nil
        weaponActionExecuteUseCase = nil
    }
    
    /*
     期待すること
     - WeaponResourceGetUseCase.getDefaultWeaponDetail()が1回だけ呼ばれること
     - 取得した武器が、useCaseのデフォルト武器として返却されるものと同じこと
     - 取得した武器の値でshowWeaponImage()が呼ばれること
     - 取得した武器の値でshowBulletsCountImage()が呼ばれること
     - 取得した武器の値でplayShowingSound()が呼ばれること
     */
    func test_viewDidLoad() throws {
        let defaultWeaponDetailMock = CurrentWeaponData(
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
        // useCaseがデフォルト武器として返却する値を上書き
        weaponResourceGetUseCaseMock.defaultWeaponDetail = defaultWeaponDetailMock
        
        XCTAssertEqual(weaponResourceGetUseCaseMock.getDefaultWeaponDetailCalledCount, 0)
        XCTAssertEqual(vcMock.showWeaponImageCalledValues, [])
        XCTAssertEqual(vcMock.showBulletsCountImageCalledValues, [])
        XCTAssertEqual(vcMock.playSoundCalledValues, [])
        
        presenter.viewDidLoad()
        
        XCTAssertEqual(weaponResourceGetUseCaseMock.getDefaultWeaponDetailCalledCount, 1)
        XCTAssertEqual(vcMock.showWeaponImageCalledValues, [defaultWeaponDetailMock.weaponImageName])
        XCTAssertEqual(vcMock.showBulletsCountImageCalledValues, [defaultWeaponDetailMock.bulletsCountImageName()])
        XCTAssertEqual(vcMock.playSoundCalledValues, [defaultWeaponDetailMock.showingSound])
    }
    
    /*
     期待すること
     - WeaponResourceGetUseCase.getWeaponDetail()が1回だけ呼ばれること
     - 引数で渡したweaponIdがgetWeaponDetailの引数にも渡されていること
     - 取得した武器が、useCaseのgetWeaponDetailで返却されるものと同じこと
     - 取得した武器の値でshowWeaponImage()が呼ばれること
     - 取得した武器の値でshowBulletsCountImage()が呼ばれること
     - 取得した武器の値でplayShowingSound()が呼ばれること
     */
    func test_weaponSelected() {
        let expectedWeapon = CurrentWeaponData(
            id: 777,
            weaponImageName: "mock_weaponImageName777",
            bulletsCountImageBaseName: "mock_bulletsCountImageBaseName777",
            capacity: 100,
            // MEMO: リロード待ち時間はテスト時も実際に待機されるので大き過ぎない値にしている
            reloadWaitingTime: 0.5,
            reloadType: .auto,
            showingSound: .bazookaSet,
            firingSound: .bazookaShoot,
            reloadingSound: .bazookaReload,
            noBulletsSound: nil,
            bulletsCount: 100,
            isReloading: false
        )
        weaponResourceGetUseCaseMock.weaponDetail = expectedWeapon
        
        XCTAssertEqual(weaponResourceGetUseCaseMock.getWeaponDetailCalledValues, [])
        XCTAssertEqual(vcMock.showWeaponImageCalledValues, [])
        XCTAssertEqual(vcMock.showBulletsCountImageCalledValues, [])
        XCTAssertEqual(vcMock.playSoundCalledValues, [])
        
        presenter.weaponSelected(weaponId: expectedWeapon.id)
        
        XCTAssertEqual(weaponResourceGetUseCaseMock.getWeaponDetailCalledValues, [expectedWeapon.id])
        XCTAssertEqual(vcMock.showWeaponImageCalledValues, [expectedWeapon.weaponImageName])
        XCTAssertEqual(vcMock.showBulletsCountImageCalledValues, [expectedWeapon.bulletsCountImageName()])
        XCTAssertEqual(vcMock.playSoundCalledValues, [expectedWeapon.showingSound])
    }
}
