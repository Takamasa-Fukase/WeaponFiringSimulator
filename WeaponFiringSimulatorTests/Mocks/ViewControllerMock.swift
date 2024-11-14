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
    var playSoundCalledValues = [SoundType]()
    var executeAutoReloadCalledCount: Int = 0

    func showWeaponImage(name: String) {
        showWeaponImageCalledValues.append(name)
    }
    
    func showBulletsCountImage(name: String) {
        showBulletsCountImageCalledValues.append(name)
    }
    
    func playSound(type: WeaponFiringSimulator.SoundType) {
        playSoundCalledValues.append(type)
    }
    
    func executeAutoReload() {
        executeAutoReloadCalledCount += 1
    }
}
