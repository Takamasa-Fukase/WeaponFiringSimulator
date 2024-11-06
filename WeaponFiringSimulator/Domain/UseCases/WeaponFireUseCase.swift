//
//  WeaponFireUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

struct WeaponFireRequest {
    let weaponType: WeaponType
    let bulletsCount: Int
    let isReloading: Bool
}

struct WeaponFireCompletedResponse {
    let firingSound: SoundType
    let bulletsCountImageBaseName: String
    let bulletsCount: Int
    let needsAutoReload: Bool
}

struct WeaponFireCanceledResponse {
    let noBulletsSound: SoundType?
}

protocol WeaponFireUseCaseInterface {
    func execute(
        request: WeaponFireRequest,
        onFired: ((WeaponFireCompletedResponse) -> Void),
        onCanceled: ((WeaponFireCanceledResponse) -> Void)
    ) throws
}

final class WeaponFireUseCase: WeaponFireUseCaseInterface {
    let weaponRepository: WeaponRepositoryInterface
    
    init(weaponRepository: WeaponRepositoryInterface) {
        self.weaponRepository = weaponRepository
    }
    
    func execute(
        request: WeaponFireRequest,
        onFired: ((WeaponFireCompletedResponse) -> Void),
        onCanceled: ((WeaponFireCanceledResponse) -> Void)
    ) throws {
        let weapon = try weaponRepository.get(by: request.weaponType)
        let canFire = Weapon.canFire(
            bulletsCount: request.bulletsCount,
            isReloading: request.isReloading
        )
        
        if canFire {
            let needsAutoReload = Weapon.needsAutoReload(
                bulletsCount: request.bulletsCount - 1,
                isReloading: request.isReloading,
                reloadType: weapon.reloadType
            )
            let response = WeaponFireCompletedResponse(
                firingSound: weapon.firingSound,
                bulletsCountImageBaseName: weapon.bulletsCountImageBaseName,
                bulletsCount: request.bulletsCount - 1,
                needsAutoReload: needsAutoReload
            )
            onFired(response)
            
        }else {
            let response = WeaponFireCanceledResponse(noBulletsSound: weapon.noBulletsSound)
            onCanceled(response)
        }
    }
}
