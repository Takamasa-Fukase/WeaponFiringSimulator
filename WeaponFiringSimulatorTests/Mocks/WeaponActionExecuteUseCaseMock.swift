//
//  WeaponActionExecuteUseCaseMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 14/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class WeaponActionExecuteUseCaseMock: WeaponActionExecuteUseCaseInterface {
    let weaponStatusCheckUseCase: WeaponStatusCheckUseCaseInterface
    var onFiredCalledValues = [WeaponFireCompletedResponse]()
    var onCanceledCalledCount: Int = 0
    var onReloadStartedCalledValues = [WeaponReloadStartedResponse]()
    var onReloadEndedCalledValues = [WeaponReloadEndedResponse]()
    
    init(weaponStatusCheckUseCase: WeaponStatusCheckUseCaseInterface) {
        self.weaponStatusCheckUseCase = weaponStatusCheckUseCase
    }
    
    func fireWeapon(bulletsCount: Int, isReloading: Bool, reloadType: ReloadType, onFired: ((WeaponFireCompletedResponse) -> Void), onCanceled: (() -> Void)) {
        let canFire = weaponStatusCheckUseCase.checkCanFire(bulletsCount: bulletsCount, isReloading: isReloading)
        
        if canFire {
            let needsAutoReload = weaponStatusCheckUseCase.checkNeedsAutoReload(bulletsCount: bulletsCount, isReloading: isReloading, reloadType: reloadType)
            
            let completedReponse = WeaponFireCompletedResponse(bulletsCount: bulletsCount - 1, needsAutoReload: needsAutoReload)
            onFired(completedReponse)
            onFiredCalledValues.append(completedReponse)
            
        }else {
            onCanceled()
            onCanceledCalledCount += 1
        }
    }
    
    func reloadWeapon(bulletsCount: Int, isReloading: Bool, capacity: Int, reloadWaitingTime: TimeInterval, onReloadStarted: ((WeaponReloadStartedResponse) -> Void), onReloadEnded: @escaping ((WeaponReloadEndedResponse) -> Void)) {
        let canReload = weaponStatusCheckUseCase.checkCanReload(bulletsCount: bulletsCount, isReloading: isReloading)

        if canReload {
            let startedResponse = WeaponReloadStartedResponse(isReloading: true)
            onReloadStarted(startedResponse)
            onReloadStartedCalledValues.append(startedResponse)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + reloadWaitingTime, execute: { [weak self] in
                let endedResponse = WeaponReloadEndedResponse(
                    bulletsCount: capacity,
                    isReloading: false
                )
                onReloadEnded(endedResponse)
                self?.onReloadEndedCalledValues.append(endedResponse)
            })
        }
    }
}
