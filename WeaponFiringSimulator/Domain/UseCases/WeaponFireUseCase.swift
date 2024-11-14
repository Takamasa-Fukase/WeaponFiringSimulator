//
//  WeaponFireUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

struct WeaponFireRequest {
    let weaponId: Int
    let bulletsCount: Int
    let isReloading: Bool
}

//struct WeaponFireCompletedResponse {
//    let bulletsCount: Int
//    let needsAutoReload: Bool
//}

protocol WeaponFireUseCaseInterface {
    func execute(
        request: WeaponFireRequest,
        onFired: ((WeaponFireCompletedResponse) -> Void),
        onCanceled: (() -> Void)
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
        onCanceled: (() -> Void)
    ) throws {
        let weapon = try weaponRepository.get(by: request.weaponId)
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
                bulletsCount: request.bulletsCount - 1,
                needsAutoReload: needsAutoReload
            )
            onFired(response)
            
        }else {
            onCanceled()
        }
    }
}
