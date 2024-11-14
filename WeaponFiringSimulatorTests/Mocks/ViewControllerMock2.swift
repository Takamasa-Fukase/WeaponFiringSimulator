//
//  ViewControllerMock2.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 13/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class ViewControllerMock2: ViewControllerInterface2 {
    var showWeaponListCalled = false
    var selectInitialItemCalled = false
    var showWeaponImageCalled = false
    var showBulletsCountImageCalled = false
    var playShowingSoundCalled = false
    var playFireSoundCalled = false
    var playReloadSoundCalled = false
    var playNoBulletsSoundCalled = false
    var executeAutoReloadCalled = false
    
    func showWeaponList() {
        showWeaponListCalled = true
    }
    
    func selectInitialItem(at indexPath: IndexPath) {
        selectInitialItemCalled = true
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
