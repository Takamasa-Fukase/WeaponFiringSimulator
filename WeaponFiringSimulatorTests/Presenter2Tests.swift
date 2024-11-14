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
    private var vcMock: ViewControllerMock2!
    private var weaponListGetUseCase: WeaponListGetUseCase!
    private var weaponFireUseCase: WeaponFireUseCase!
    private var weaponReloadUseCase: WeaponReloadUseCase!
    private var weaponChangeUseCase: WeaponChangeUseCase!
    private var weaponRepositoryMock: WeaponRepositoryMock!
    
    override func setUpWithError() throws {
        vcMock = ViewControllerMock2()
        weaponRepositoryMock = WeaponRepositoryMock()
        weaponListGetUseCase = WeaponListGetUseCase(weaponRepository: weaponRepositoryMock)
        weaponFireUseCase = WeaponFireUseCase(weaponRepository: weaponRepositoryMock)
        weaponReloadUseCase = WeaponReloadUseCase(weaponRepository: weaponRepositoryMock)
        weaponChangeUseCase = WeaponChangeUseCase(weaponRepository: weaponRepositoryMock)
        presenter = .init(view: vcMock,
                          weaponListGetUseCase: weaponListGetUseCase,
                          weaponFireUseCase: weaponFireUseCase,
                          weaponReloadUseCase: weaponReloadUseCase,
                          weaponChangeUseCase: weaponChangeUseCase)
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        vcMock = nil
        weaponListGetUseCase = nil
        weaponFireUseCase = nil
        weaponReloadUseCase = nil
        weaponChangeUseCase = nil
    }
    
    func test_viewDidLoad_武器一覧表示と初期アイテム選択が実行されたら成功() throws {
        XCTAssertEqual(false, vcMock.showWeaponListCalled)
        XCTAssertEqual(false, vcMock.selectInitialItemCalled)
        
        presenter.viewDidLoad()

        XCTAssertEqual(true, vcMock.showWeaponListCalled)
        XCTAssertEqual(true, vcMock.selectInitialItemCalled)
    }
    
    func test_fireButtonTapped_canFireがtrueでneedsAutoReloadがfalseの時に弾数と発射音声再生と弾数画像が更新される且つ自動リロードと弾切れ音声が呼ばれなければ成功() throws {
        // 武器リストに値を入れる
        presenter.setWeaponListItems([
            .init(
                weaponId: 0,
                weaponImageName: "pistol"
            ),
            .init(
                weaponId: 1,
                weaponImageName: "bazooka"
            )
        ])
        
        
        
        // TODO: bulletsCountの更新処理が呼ばれたかどうかをチェックしたい
//        XCTAssertEqual(false, vcMock.updateBulletsCountCalled)
        
        XCTAssertEqual(false, vcMock.playFireSoundCalled)
        XCTAssertEqual(false, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)
        XCTAssertEqual(false, vcMock.playNoBulletsSoundCalled)

        
        
        presenter.fireButtonTapped(selectedIndex: 0)

//        XCTAssertEqual(true, vcMock.updateBulletsCountCalled)
        
        XCTAssertEqual(true, vcMock.playFireSoundCalled)
        XCTAssertEqual(true, vcMock.showBulletsCountImageCalled)
        XCTAssertEqual(false, vcMock.executeAutoReloadCalled)
        XCTAssertEqual(false, vcMock.playNoBulletsSoundCalled)
    }
}
