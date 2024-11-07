//
//  CanFireCheckUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 8/11/24.
//

import Foundation

struct CanFireCheckRequest {
    let bulletsCount: Int
    let isReloading: Bool
}

struct CanFireCheckResponse {
    let canFire: Bool
}

protocol CanFireCheckUseCaseInterface {
    func execute(
        request: CanFireCheckRequest
    ) -> CanFireCheckResponse
}

final class CanFireCheckUseCase: CanFireCheckUseCaseInterface {
    func execute(
        request: CanFireCheckRequest
    ) -> CanFireCheckResponse {
        let canFire: Bool = {
            if request.isReloading { return false }
            if request.bulletsCount > 0 {
                return true
            }else {
                return false
            }
        }()
        return .init(canFire: canFire)
    }
}
