//
//  ViewControllerMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 13/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class ViewControllerMock: ViewControllerInterface {
    var showWeaponImageCalledValues = [String]()
    var showBulletsCountImageCalledValues = [String]()
    var playShowingSoundCalledValues = [SoundType]()
    var playFireSoundCalledValues = [SoundType]()
    var playReloadSoundCalledValues = [SoundType]()
    var playNoBulletsSoundCalledValues = [SoundType]()
    var executeAutoReloadCalledValues = [Void]()

    func showWeaponImage(name: String) {
        showWeaponImageCalledValues.append(name)
    }
    
    func showBulletsCountImage(name: String) {
        showBulletsCountImageCalledValues.append(name)
    }
    
    func playShowingSound(type: WeaponFiringSimulator.SoundType) {
        playShowingSoundCalledValues.append(type)
    }
    
    func playFireSound(type: WeaponFiringSimulator.SoundType) {
        playFireSoundCalledValues.append(type)
    }
    
    func playReloadSound(type: WeaponFiringSimulator.SoundType) {
        playReloadSoundCalledValues.append(type)
    }
    
    func playNoBulletsSound(type: WeaponFiringSimulator.SoundType) {
        playNoBulletsSoundCalledValues.append(type)
    }
    
    func executeAutoReload() {
        executeAutoReloadCalledValues.append(Void())
    }
}
