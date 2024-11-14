//
//  WeaponReloadUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

struct WeaponReloadRequest {
    let weaponId: Int
    let bulletsCount: Int
    let isReloading: Bool
}

//struct WeaponReloadStartedResponse {
//    let isReloading: Bool
//}
//
//struct WeaponReloadEndedResponse {
//    let bulletsCount: Int
//    let isReloading: Bool
//}

protocol WeaponReloadUseCaseInterface {
    func execute(
        request: WeaponReloadRequest,
        onReloadStarted: ((WeaponReloadStartedResponse) -> Void),
        onReloadEnded: @escaping ((WeaponReloadEndedResponse) -> Void)
    ) throws
}

final class WeaponReloadUseCase: WeaponReloadUseCaseInterface {
    let weaponRepository: WeaponRepositoryInterface
    let canReloadCheckUseCase: CanReloadCheckUseCaseInterface
    
    init(
        weaponRepository: WeaponRepositoryInterface,
        canReloadCheckUseCase: CanReloadCheckUseCaseInterface
    ) {
        self.weaponRepository = weaponRepository
        self.canReloadCheckUseCase = canReloadCheckUseCase
    }
    
    func execute(
        request: WeaponReloadRequest,
        onReloadStarted: ((WeaponReloadStartedResponse) -> Void),
        onReloadEnded: @escaping ((WeaponReloadEndedResponse) -> Void)
    ) throws {
        let weapon = try weaponRepository.get(by: request.weaponId)
        let canReloadCheckRequest = CanReloadCheckRequest(
            bulletsCount: request.bulletsCount,
            isReloading: request.isReloading
        )
        let canReload = canReloadCheckUseCase.execute(request: canReloadCheckRequest).canReload

        if canReload {
            let startedResponse = WeaponReloadStartedResponse(
                isReloading: true
            )
            onReloadStarted(startedResponse)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + weapon.reloadWaitingTime, execute: {
                let endedResponse = WeaponReloadEndedResponse(
                    bulletsCount: weapon.capacity,
                    isReloading: false
                )
                onReloadEnded(endedResponse)
            })
        }
    }
}
