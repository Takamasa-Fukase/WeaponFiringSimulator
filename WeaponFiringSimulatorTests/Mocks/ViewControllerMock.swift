//
//  ViewControllerMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 6/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class ViewControllerMock: ViewControllerInterface {
    var updateWeaponTypeCalled = false
    var updateBulletsCountCalled = false
    var updateReloadingFlagCalled = false
    var updateReloadingFlagCalledValues: [Bool] = []
    var showWeaponImageCalled = false
    var showBulletsCountImageCalled = false
    var playShowingSoundCalled = false
    var playFireSoundCalled = false
    var playReloadSoundCalled = false
    var playNoBulletsSoundCalled = false
    var executeAutoReloadCalled = false
    
    func updateWeaponType(_ weaponType: WeaponFiringSimulator.WeaponType) {
        updateWeaponTypeCalled = true
    }
    
    func updateBulletsCount(_ bulletsCount: Int) {
        updateBulletsCountCalled = true
    }
    
    func updateReloadingFlag(_ isReloading: Bool) {
        updateReloadingFlagCalled = true
        updateReloadingFlagCalledValues.append(isReloading)
    }
    
    func showWeaponImage(name: String) {
        showWeaponImageCalled = true
    }
    
    func showBulletsCountImage(name: String) {
        showBulletsCountImageCalled = true
    }
    
    func playShowingSound(type: WeaponFiringSimulator.SoundType) {
        playShowingSoundCalled = true
    }
    
    func playFireSound(type: WeaponFiringSimulator.SoundType) {
        playFireSoundCalled = true
    }
    
    func playReloadSound(type: WeaponFiringSimulator.SoundType) {
        playReloadSoundCalled = true
    }
    
    func playNoBulletsSound(type: WeaponFiringSimulator.SoundType) {
        playNoBulletsSoundCalled = true
    }
    
    func executeAutoReload() {
        executeAutoReloadCalled = true
    }
}
