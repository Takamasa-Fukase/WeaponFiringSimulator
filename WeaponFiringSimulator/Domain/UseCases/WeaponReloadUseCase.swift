//
//  WeaponReloadUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

struct WeaponReloadRequest {
    let weaponType: WeaponType
    let bulletsCount: Int
    let isReloading: Bool
}

struct WeaponReloadStartedResponse {
    let reloadingSound: SoundType
    let isReloading: Bool
}

struct WeaponReloadEndedResponse {
    let bulletsCountImageBaseName: String
    let bulletsCount: Int
    let isReloading: Bool
}

class WeaponReloadUseCase {
    let weaponRepository: WeaponRepositoryInterface
    
    init(weaponRepository: WeaponRepositoryInterface) {
        self.weaponRepository = weaponRepository
    }
    
    func execute(
        request: WeaponReloadRequest,
        onReloadStarted: ((WeaponReloadStartedResponse) -> Void),
        onReloadEnded: @escaping ((WeaponReloadEndedResponse) -> Void)
    ) throws {
        let weapon = try weaponRepository.get(by: request.weaponType)
        let canReload = Weapon.canReload(
            bulletsCount: request.bulletsCount,
            isReloading: request.isReloading
        )

        if canReload {
            let startedResponse = WeaponReloadStartedResponse(
                reloadingSound: weapon.reloadingSound,
                isReloading: true
            )
            onReloadStarted(startedResponse)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + weapon.reloadWaitingTime, execute: {
                let endedResponse = WeaponReloadEndedResponse(
                    bulletsCountImageBaseName: weapon.bulletsCountImageBaseName,
                    bulletsCount: weapon.capacity,
                    isReloading: false
                )
                onReloadEnded(endedResponse)
            })
        }
    }
}
