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
    
    func test_viewDidLoad_武器タイプと弾数とリロード中フラグが全て更新されたら成功() throws {
        XCTAssertEqual(false, vcMock.updateWeaponTypeCalled)
        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.updateReloadingFlagCalled)

        presenter.viewDidLoad()

        XCTAssertEqual(true, vcMock.updateWeaponTypeCalled)
        XCTAssertEqual(true, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(true, vcMock.updateReloadingFlagCalled)
    }
    
    func test_fireButtonTapped_canFireがtrueでneedsAutoReloadがfalseの時にピストルでFireボタンを押したら弾数と発射音声再生と弾数画像が更新される且つ自動リロードが呼ばれなければ成功() throws {
        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.playFireSoundCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)

        // 撃てる様にする
        weaponFireUseCaseMock.canFire = true
        // 自動リロードしない様にする
        weaponFireUseCaseMock.needsAutoReload = false
        presenter.fireButtonTapped(weaponType: .pistol, bulletsCount: 7, isReloading: false)

        XCTAssertEqual(true, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(true, vcMock.playFireSoundCalled)
        XCTAssertEqual(true, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)
    }
    
    func test_fireButtonTapped_canFireがfalseでneedsAutoReloadがfalseの時にピストルでFireボタンを押したら弾数と発射音声再生と弾数画像が更新されない且つ自動リロードも呼ばれなければ成功() throws {
        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.playFireSoundCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)

        // 撃てない様にする
        weaponFireUseCaseMock.canFire = false
        // 自動リロードしない様にする
        weaponFireUseCaseMock.needsAutoReload = false
        presenter.fireButtonTapped(weaponType: .pistol, bulletsCount: 7, isReloading: false)

        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.playFireSoundCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)
    }
    
    func test_fireButtonTapped_canFireがtrueでneedsAutoReloadがtrueの時にピストルでFireボタンを押したら弾数と発射音声再生と弾数画像が更新される且つ自動リロードも呼ばれたら成功() throws {
        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.playFireSoundCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)

        // 撃てる様にする
        weaponFireUseCaseMock.canFire = true
        // 自動リロードする様にする
        weaponFireUseCaseMock.needsAutoReload = true
        presenter.fireButtonTapped(weaponType: .pistol, bulletsCount: 7, isReloading: false)

        XCTAssertEqual(true, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(true, vcMock.playFireSoundCalled)
        XCTAssertEqual(true, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(true, vcMock.executeAutoReloadCalled)
    }
    
    func test_fireButtonTapped_canFireがfalseでneedsAutoReloadがtrueの時にピストルでFireボタンを押したら弾数と発射音声再生と弾数画像が更新されない且つ自動リロードも呼ばれなければ成功() throws {
        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.playFireSoundCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)

        // 撃てない様にする
        weaponFireUseCaseMock.canFire = false
        // 自動リロードする様にする
        weaponFireUseCaseMock.needsAutoReload = true
        presenter.fireButtonTapped(weaponType: .pistol, bulletsCount: 7, isReloading: false)

        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.playFireSoundCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)
    }
}
