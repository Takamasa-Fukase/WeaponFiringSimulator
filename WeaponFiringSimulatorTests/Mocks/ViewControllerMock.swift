//
//  ViewControllerMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 13/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class ViewControllerMock: ViewControllerInterface {
    var showWeaponImageCalled = false
    var showBulletsCountImageCalled = false
    var playShowingSoundCalled = false
    var playFireSoundCalled = false
    var playReloadSoundCalled = false
    var playNoBulletsSoundCalled = false
    var executeAutoReloadCalled = false
    
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
