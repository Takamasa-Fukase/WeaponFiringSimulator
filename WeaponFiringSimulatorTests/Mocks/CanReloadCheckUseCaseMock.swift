//
//  CanReloadCheckUseCaseMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 8/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class CanReloadCheckUseCaseMock: CanReloadCheckUseCaseInterface {
    var canReload = false
    
    func execute(request: CanReloadCheckRequest) -> CanReloadCheckResponse {
        return .init(canReload: canReload)
    }
}
