//
//  CanReloadCheckUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 8/11/24.
//

import Foundation

struct CanReloadCheckRequest {
    let bulletsCount: Int
    let isReloading: Bool
}

struct CanReloadCheckResponse {
    let canReload: Bool
}

protocol CanReloadCheckUseCaseInterface {
    func execute(
        request: CanReloadCheckRequest
    ) -> CanReloadCheckResponse
}

final class CanReloadCheckUseCase: CanReloadCheckUseCaseInterface {
    func execute(
        request: CanReloadCheckRequest
    ) -> CanReloadCheckResponse {
        let canReload: Bool = {
            if request.isReloading { return false }
            if request.bulletsCount <= 0 {
                return true
            }else {
                return false
            }
        }()
        return .init(canReload: canReload)
    }
}
