//
//  NeedsAutoReloadCheckUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 8/11/24.
//

import Foundation

struct NeedsAutoReloadCheckRequest {
    let bulletsCount: Int
    let isReloading: Bool
    let reloadType: ReloadType
}

struct NeedsAutoReloadCheckResponse {
    let needsAutoReload: Bool
}

protocol NeedsAutoReloadCheckUseCaseInterface {
    func execute(
        request: NeedsAutoReloadCheckRequest
    ) -> NeedsAutoReloadCheckResponse
}

final class NeedsAutoReloadCheckUseCase: NeedsAutoReloadCheckUseCaseInterface {
    func execute(
        request: NeedsAutoReloadCheckRequest
    ) -> NeedsAutoReloadCheckResponse {
        let needsAutoReload: Bool = {
            if request.isReloading { return false }
            if request.bulletsCount == 0 && request.reloadType == .auto {
                return true
            }else {
                return false
            }
        }()
        return .init(needsAutoReload: needsAutoReload)
    }
}
