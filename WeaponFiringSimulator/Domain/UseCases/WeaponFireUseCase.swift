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
    let canFireCheckUseCase: CanFireCheckUseCaseInterface
    let needsAutoReloadCheckUseCase: NeedsAutoReloadCheckUseCaseInterface
    
    init(
        weaponRepository: WeaponRepositoryInterface,
        canFireCheckUseCase: CanFireCheckUseCaseInterface,
        needsAutoReloadCheckUseCase: NeedsAutoReloadCheckUseCaseInterface
    ) {
        self.weaponRepository = weaponRepository
        self.canFireCheckUseCase = canFireCheckUseCase
        self.needsAutoReloadCheckUseCase = needsAutoReloadCheckUseCase
    }
    
    func execute(
        request: WeaponFireRequest,
        onFired: ((WeaponFireCompletedResponse) -> Void),
        onCanceled: ((WeaponFireCanceledResponse) -> Void)
    ) throws {
        let weapon = try weaponRepository.get(by: request.weaponType)
        let canFireCheckRequest = CanFireCheckRequest(
            bulletsCount: request.bulletsCount,
            isReloading: request.isReloading
        )
        let canFire = canFireCheckUseCase.execute(request: canFireCheckRequest).canFire
        
        if canFire {
            let needsAutoReloadCheckRequest = NeedsAutoReloadCheckRequest(
                bulletsCount: request.bulletsCount - 1,
                isReloading: request.isReloading,
                reloadType: weapon.reloadType
            )
            let needsAutoReload = needsAutoReloadCheckUseCase.execute(request: needsAutoReloadCheckRequest).needsAutoReload
            
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
