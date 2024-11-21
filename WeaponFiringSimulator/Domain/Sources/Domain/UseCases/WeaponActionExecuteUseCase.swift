//
//  WeaponActionExecuteUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 14/11/24.
//

import Foundation

public protocol WeaponActionExecuteUseCaseInterface {
    func fireWeapon(bulletsCount: Int,
                    isReloading: Bool,
                    reloadType: ReloadType,
                    onFired: ((WeaponFireCompletedResponse) -> Void),
                    onCanceled: (() -> Void))
    func reloadWeapon(bulletsCount: Int,
                      isReloading: Bool,
                      capacity: Int,
                      reloadWaitingTime: TimeInterval,
                      onReloadStarted: ((WeaponReloadStartedResponse) -> Void),
                      onReloadEnded: @escaping ((WeaponReloadEndedResponse) -> Void))
}

public struct WeaponFireCompletedResponse {
    public let bulletsCount: Int
    public let needsAutoReload: Bool
}

public struct WeaponReloadStartedResponse {
    public let isReloading: Bool
}

public struct WeaponReloadEndedResponse {
    public let bulletsCount: Int
    public let isReloading: Bool
}

public final class WeaponActionExecuteUseCase {
    private let weaponStatusCheckUseCase: WeaponStatusCheckUseCaseInterface
    
    public init(weaponStatusCheckUseCase: WeaponStatusCheckUseCaseInterface) {
        self.weaponStatusCheckUseCase = weaponStatusCheckUseCase
    }
}

extension WeaponActionExecuteUseCase: WeaponActionExecuteUseCaseInterface {
    public func fireWeapon(bulletsCount: Int, isReloading: Bool, reloadType: ReloadType, onFired: ((WeaponFireCompletedResponse) -> Void), onCanceled: (() -> Void)) {
        let canFire = weaponStatusCheckUseCase.checkCanFire(bulletsCount: bulletsCount, isReloading: isReloading)
        
        if canFire {
            let needsAutoReload = weaponStatusCheckUseCase.checkNeedsAutoReload(bulletsCount: bulletsCount, isReloading: isReloading, reloadType: reloadType)
            
            let completedReponse = WeaponFireCompletedResponse(bulletsCount: bulletsCount - 1, needsAutoReload: needsAutoReload)
            onFired(completedReponse)
            
        }else {
            onCanceled()
        }
    }
    
    public func reloadWeapon(bulletsCount: Int, isReloading: Bool, capacity: Int, reloadWaitingTime: TimeInterval, onReloadStarted: ((WeaponReloadStartedResponse) -> Void), onReloadEnded: @escaping ((WeaponReloadEndedResponse) -> Void)) {
        let canReload = weaponStatusCheckUseCase.checkCanReload(bulletsCount: bulletsCount, isReloading: isReloading)

        if canReload {
            let startedResponse = WeaponReloadStartedResponse(isReloading: true)
            onReloadStarted(startedResponse)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + reloadWaitingTime, execute: {
                let endedResponse = WeaponReloadEndedResponse(
                    bulletsCount: capacity,
                    isReloading: false
                )
                onReloadEnded(endedResponse)
            })
        }
    }
}