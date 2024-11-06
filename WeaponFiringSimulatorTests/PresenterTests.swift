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
    
    func test_viewDidLoad_武器タイプと弾数とリロード中フラグが全て更新される且つ武器画像と弾数画像の表示と表示音声が再生されたら成功() throws {
        XCTAssertEqual(false, vcMock.updateWeaponTypeCalled)
        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.updateReloadingFlagCalled)
        XCTAssertEqual(false, vcMock.showWeaponImageCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.playShowingSoundCalled)
        
        presenter.viewDidLoad()

        XCTAssertEqual(true, vcMock.updateWeaponTypeCalled)
        XCTAssertEqual(true, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(true, vcMock.updateReloadingFlagCalled)
        XCTAssertEqual(true, vcMock.showWeaponImageCalled)
        XCTAssertEqual(true, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(true, vcMock.playShowingSoundCalled)
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
        presenter.fireButtonTapped(weaponType: .pistol, bulletsCount: 7, isReloading: false)

        XCTAssertEqual(true, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(true, vcMock.playFireSoundCalled)
        XCTAssertEqual(true, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)
        XCTAssertEqual(false, vcMock.playNoBulletsSoundCalled)
    }
    
    func test_fireButtonTapped_canFireがfalseでneedsAutoReloadがfalseの時に弾数と発射音声再生と弾数画像が更新されない且つ自動リロードも呼ばれない且つ弾切れ音声が呼ばれれば成功() throws {
        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.playFireSoundCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)
        XCTAssertEqual(false, vcMock.playNoBulletsSoundCalled)

        // 撃てない様にする
        weaponFireUseCaseMock.canFire = false
        // 自動リロードしない様にする
        weaponFireUseCaseMock.needsAutoReload = false
        presenter.fireButtonTapped(weaponType: .pistol, bulletsCount: 7, isReloading: false)

        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.playFireSoundCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)
        XCTAssertEqual(true, vcMock.playNoBulletsSoundCalled)
    }
    
    func test_fireButtonTapped_canFireがtrueでneedsAutoReloadがtrueの時に弾数と発射音声再生と弾数画像が更新される且つ自動リロードも呼ばれる且つ弾切れ音声が呼ばれなければ成功() throws {
        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.playFireSoundCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)
        XCTAssertEqual(false, vcMock.playNoBulletsSoundCalled)

        // 撃てる様にする
        weaponFireUseCaseMock.canFire = true
        // 自動リロードする様にする
        weaponFireUseCaseMock.needsAutoReload = true
        presenter.fireButtonTapped(weaponType: .pistol, bulletsCount: 7, isReloading: false)

        XCTAssertEqual(true, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(true, vcMock.playFireSoundCalled)
        XCTAssertEqual(true, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(true, vcMock.executeAutoReloadCalled)
        XCTAssertEqual(false, vcMock.playNoBulletsSoundCalled)
    }
    
    func test_fireButtonTapped_canFireがfalseでneedsAutoReloadがtrueの時に弾数と発射音声再生と弾数画像が更新されない且つ自動リロードも呼ばれない且つ弾切れ音声が呼ばれれば成功() throws {
        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.playFireSoundCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)
        XCTAssertEqual(false, vcMock.playNoBulletsSoundCalled)

        // 撃てない様にする
        weaponFireUseCaseMock.canFire = false
        // 自動リロードする様にする
        weaponFireUseCaseMock.needsAutoReload = true
        presenter.fireButtonTapped(weaponType: .pistol, bulletsCount: 7, isReloading: false)

        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.playFireSoundCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)
        XCTAssertEqual(true, vcMock.playNoBulletsSoundCalled)
    }
    
    func test_changeWeaponButtonTapped_武器タイプと弾数とリロード中フラグが全て更新される且つ武器画像と弾数画像の表示と表示音声が再生されたら成功() throws {
        XCTAssertEqual(false, vcMock.updateWeaponTypeCalled)
        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(false, vcMock.updateReloadingFlagCalled)
        XCTAssertEqual(false, vcMock.showWeaponImageCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.playShowingSoundCalled)
        
        presenter.changeWeaponButtonTapped(weaponType: .pistol)

        XCTAssertEqual(true, vcMock.updateWeaponTypeCalled)
        XCTAssertEqual(true, vcMock.updateBulletsCountCalled)
        XCTAssertEqual(true, vcMock.updateReloadingFlagCalled)
        XCTAssertEqual(true, vcMock.showWeaponImageCalled)
        XCTAssertEqual(true, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(true, vcMock.playShowingSoundCalled)
    }
}
