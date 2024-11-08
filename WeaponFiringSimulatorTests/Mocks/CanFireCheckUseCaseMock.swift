//
//  CanFireCheckUseCaseMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 8/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class CanFireCheckUseCaseMock: CanFireCheckUseCaseInterface {
    var canFire = false
    
    func execute(request: CanFireCheckRequest) -> CanFireCheckResponse {
        return .init(canFire: canFire)
    }
}
