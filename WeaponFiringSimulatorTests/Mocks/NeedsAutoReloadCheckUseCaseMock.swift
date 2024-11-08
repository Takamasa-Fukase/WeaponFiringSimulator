//
//  NeedsAutoReloadCheckUseCaseMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 8/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class NeedsAutoReloadCheckUseCaseMock: NeedsAutoReloadCheckUseCaseInterface {
    var needsAutoReload = false
    
    func execute(request: NeedsAutoReloadCheckRequest) -> NeedsAutoReloadCheckResponse {
        return .init(needsAutoReload: needsAutoReload)
    }
}
