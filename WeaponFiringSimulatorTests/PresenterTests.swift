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
    private var weaponActionExecuteUseCaseMock: WeaponActionExecuteUseCaseMock!
    
    override func setUpWithError() throws {
        vcMock = ViewControllerMock()
        weaponResourceGetUseCaseMock = .init()
        weaponActionExecuteUseCaseMock = .init(weaponStatusCheckUseCase: WeaponStatusCheckUseCase())
        presenter = .init(view: vcMock,
                          weaponResourceGetUseCase: weaponResourceGetUseCaseMock,
                          weaponActionExecuteUseCase: weaponActionExecuteUseCaseMock)
    }
    
    override func tearDownWithError() throws {
        vcMock = nil
        weaponResourceGetUseCaseMock = nil
        weaponActionExecuteUseCaseMock = nil
    }
    
    // MARK: viewDidLoad()のテスト
    
    /*
     期待すること
     - WeaponResourceGetUseCase.getDefaultWeaponDetail()が1回だけ呼ばれること
     - 取得した武器が、useCaseのデフォルト武器として返却されるものと同じこと
     - 取得した武器の値でshowWeaponImage()が呼ばれること
     - 取得した武器の値でshowBulletsCountImage()が呼ばれること
     - 取得した武器の値でplaySound()が呼ばれること
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
        XCTAssertEqual(vcMock.showWeaponImageCalledValues, ["mock_weaponImageName"])
        XCTAssertEqual(vcMock.showBulletsCountImageCalledValues, ["mock_bulletsCountImageBaseName100"])
        XCTAssertEqual(vcMock.playSoundCalledValues, [.pistolSet])
    }
    
    // MARK: fireButtonTapped()のテスト
    
    /*
     期待すること
     currentWeaponDataのbulletsCountが2でisReloading＝falseでreloadType＝manualの時
     - onFiredが1回だけ呼ばれること
     - currentWeaponDataのbulletsCountが1つ減っていること
     - currentWeaponDataのfiringSoundでplaySound()が1回だけ呼ばれること
     - 1つ減っているbulletsCountでshowBulletsCountImage()が1回だけ呼ばれていること
     - executeAutoReload()が呼ばれないこと
     - onCanceledが呼ばれないこと
     */
    func test_fireButtonTapped_currentWeaponDataのbulletsCountが2でisReloading＝falseでreloadType＝manualの時() throws {
        let currentWeaponData = CurrentWeaponData(
            id: 100,
            weaponImageName: "",
            bulletsCountImageBaseName: "mock_bulletsCountImageBaseName",
            capacity: 100,
            reloadWaitingTime: 0.5,
            reloadType: .manual,
            showingSound: .pistolSet,
            firingSound: .pistolShoot,
            reloadingSound: .pistolReload,
            noBulletsSound: .pistolOutBullets,
            bulletsCount: 2,
            isReloading: false
        )
        presenter.setCurrentWeaponData(currentWeaponData)
        
        XCTAssertEqual(weaponActionExecuteUseCaseMock.onFiredCalledValues.count, 0)
        XCTAssertEqual(presenter.getCurrentWeaponData()?.bulletsCount ?? 0, 2)
        XCTAssertEqual(vcMock.playSoundCalledValues, [])
        XCTAssertEqual(vcMock.showBulletsCountImageCalledValues, [])
        XCTAssertEqual(vcMock.executeAutoReloadCalledCount, 0)
        XCTAssertEqual(weaponActionExecuteUseCaseMock.onCanceledCalledCount, 0)
        
        presenter.fireButtonTapped()
        
        XCTAssertEqual(weaponActionExecuteUseCaseMock.onFiredCalledValues.count, 1)
        XCTAssertEqual(presenter.getCurrentWeaponData()?.bulletsCount ?? 0, 1)
        XCTAssertEqual(vcMock.playSoundCalledValues, [.pistolShoot])
        XCTAssertEqual(vcMock.showBulletsCountImageCalledValues, ["mock_bulletsCountImageBaseName1"])
        XCTAssertEqual(vcMock.executeAutoReloadCalledCount, 0)
        XCTAssertEqual(weaponActionExecuteUseCaseMock.onCanceledCalledCount, 0)
    }
    
    // MARK: reloadButtonTapped()のテスト
    /*
     期待すること
     currentWeaponDataのbulletsCountが0でisReloading＝falseの時
     <reloadWaitingTimeの経過前>
     - onReloadStartedが1回だけ呼ばれること
     - isReloadingがtrueになっていること
     - currentWeaponDataのreloadingSoundでplaySound()が1回だけ呼ばれること
     
     <reloadWaitingTimeの経過後>
     - onReloadEndedが1回だけ呼ばれること
     - bulletsCountがcurrentWeaponDataのcapacityと同じになっていること
     - isReloadingがfalseになっていること
     - capacityと同じbulletsCountでshowBulletsCountImage()が1回だけ呼ばれていること
     */
    func test_reloadButtonTapped_currentWeaponDataのbulletsCountが0でisReloading＝falseの時() throws {
        
    }
    
    // MARK: weaponSelected()のテスト

    /*
     期待すること
     - WeaponResourceGetUseCase.getWeaponDetail()が1回だけ呼ばれること
     - 引数で渡したweaponIdがgetWeaponDetailの引数にも渡されていること
     - 取得した武器が、useCaseのgetWeaponDetailで返却されるものと同じこと
     - 取得した武器の値でshowWeaponImage()が呼ばれること
     - 取得した武器の値でshowBulletsCountImage()が呼ばれること
     - 取得した武器の値でplaySound()が呼ばれること
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
        
        XCTAssertEqual(weaponResourceGetUseCaseMock.getWeaponDetailCalledValues, [777])
        XCTAssertEqual(vcMock.showWeaponImageCalledValues, ["mock_weaponImageName777"])
        XCTAssertEqual(vcMock.showBulletsCountImageCalledValues, ["mock_bulletsCountImageBaseName777100"])
        XCTAssertEqual(vcMock.playSoundCalledValues, [.bazookaSet])
    }
}
