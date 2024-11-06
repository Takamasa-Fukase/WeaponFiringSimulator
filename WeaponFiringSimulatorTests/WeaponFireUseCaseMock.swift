//
//  WeaponFireUseCaseMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 6/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class WeaponFireUseCaseMock: WeaponFireUseCaseInterface {
    var canFire = false
    
    func execute(
        request: WeaponFiringSimulator.WeaponFireRequest,
        onFired: ((WeaponFiringSimulator.WeaponFireCompletedResponse) -> Void),
        onCanceled: ((WeaponFiringSimulator.WeaponFireCanceledResponse) -> Void)
    ) throws {
        if canFire {
            let response = WeaponFireCompletedResponse(
                firingSound: .pistolShoot,
                bulletsCountImageBaseName: "",
                bulletsCount: 0,
                needsAutoReload: false
            )
            onFired(response)
            
        }else {
            let response = WeaponFireCanceledResponse(noBulletsSound: .pistolOutBullets)
            onCanceled(response)
        }
    }
}
