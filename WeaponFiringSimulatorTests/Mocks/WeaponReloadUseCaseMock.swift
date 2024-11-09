//
//  WeaponReloadUseCaseMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 6/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class WeaponReloadUseCaseMock: WeaponReloadUseCaseInterface {
    var canReload = false
    
    func execute(
        request: WeaponReloadRequest,
        onReloadStarted: ((WeaponReloadStartedResponse) -> Void),
        onReloadEnded: @escaping ((WeaponReloadEndedResponse) -> Void)
    ) throws {
        if canReload {
            let startedResponse = WeaponReloadStartedResponse(
                reloadingSound: .pistolReload,
                isReloading: true
            )
            onReloadStarted(startedResponse)
            let endedResponse = WeaponReloadEndedResponse(
                bulletsCountImageName: "",
                bulletsCount: 0,
                isReloading: false
            )
            onReloadEnded(endedResponse)
        }
    }
}
