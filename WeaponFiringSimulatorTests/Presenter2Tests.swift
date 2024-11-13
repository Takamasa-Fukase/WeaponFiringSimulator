//
//  Presenter2Tests.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 13/11/24.
//

import XCTest
@testable import WeaponFiringSimulator

final class Presenter2Tests: XCTestCase {
    private var presenter: Presenter2!
    private var vcMock: ViewControllerMock!
    private var weaponListGetUseCaseMock: WeaponListGetUseCaseMock!
    private var weaponFireUseCaseMock: WeaponFireUseCaseMock!
    private var weaponReloadUseCaseMock: WeaponReloadUseCaseMock!
    private var weaponChangeUseCaseMock: WeaponChangeUseCaseMock!
    
    override func setUpWithError() throws {
        vcMock = ViewControllerMock()
        weaponListGetUseCaseMock = WeaponListGetUseCaseMock()
        weaponFireUseCaseMock = WeaponFireUseCaseMock()
        weaponReloadUseCaseMock = WeaponReloadUseCaseMock()
        weaponChangeUseCaseMock = WeaponChangeUseCaseMock()
        presenter = .init(view: vcMock,
                          weaponListGetUseCase: weaponListGetUseCaseMock,
                          weaponFireUseCase: weaponFireUseCaseMock,
                          weaponReloadUseCase: weaponReloadUseCaseMock,
                          weaponChangeUseCase: weaponChangeUseCaseMock)
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        vcMock = nil
        weaponListGetUseCaseMock = nil
        weaponFireUseCaseMock = nil
        weaponReloadUseCaseMock = nil
        weaponChangeUseCaseMock = nil
    }
    
    func test_viewDidLoad_武器一覧表示と初期アイテム選択が実行されたら成功() throws {
        XCTAssertEqual(false, vcMock.showWeaponListCalled)
        XCTAssertEqual(false, vcMock.selectInitialItemCalled)
        
        presenter.viewDidLoad()

        XCTAssertEqual(true, vcMock.showWeaponListCalled)
        XCTAssertEqual(true, vcMock.selectInitialItemCalled)
    }
    
    func test_fireButtonTapped_canFireがtrueでneedsAutoReloadがfalseの時に弾数と発射音声再生と弾数画像が更新される且つ自動リロードと弾切れ音声が呼ばれなければ成功() throws {
        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.playFireSoundCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)
        XCTAssertEqual(false, vcMock.playNoBulletsSoundCalled)

        // 撃てる様にする
        weaponFireUseCaseMock.canFire = true
        // 自動リロードしない様にする
        weaponFireUseCaseMock.needsAutoReload = false
        presenter.fireButtonTapped(selectedIndex: 0)

        XCTAssertEqual(true, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(true, vcMock.playFireSoundCalled)
        XCTAssertEqual(true, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)
        XCTAssertEqual(false, vcMock.playNoBulletsSoundCalled)
    }
}
