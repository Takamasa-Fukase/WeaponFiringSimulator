//
//  WeaponChangeUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

struct WeaponChangeRequest {
    let nextWeaponId: Int
}

struct WeaponDataModel {
    let id: Int
    let weaponImageName: String
    let bulletsCountImageBaseName: String
    let capacity: Int
    let reloadWaitingTime: TimeInterval
    let reloadType: ReloadType
    let showingSound: SoundType
    let firingSound: SoundType
    let reloadingSound: SoundType
    let noBulletsSound: SoundType?
}

struct WeaponChangeResponse {
    let data: WeaponDataModel
}

protocol WeaponChangeUseCaseInterface {
    func execute(
        request: WeaponChangeRequest,
        onCompleted: ((WeaponChangeResponse) -> Void)
    ) throws
}

final class WeaponChangeUseCase: WeaponChangeUseCaseInterface {
    let weaponRepository: WeaponRepositoryInterface
    
    init(weaponRepository: WeaponRepositoryInterface) {
        self.weaponRepository = weaponRepository
    }
    
    func execute(
        request: WeaponChangeRequest,
        onCompleted: ((WeaponChangeResponse) -> Void)
    ) throws {
        let newWeapon = try weaponRepository.get(by: request.nextWeaponId)
        let response = WeaponChangeResponse(
            data: WeaponDataModel(
                id: newWeapon.id,
                weaponImageName: newWeapon.weaponImageName,
                bulletsCountImageBaseName: newWeapon.bulletsCountImageBaseName,
                capacity: newWeapon.capacity,
                reloadWaitingTime: newWeapon.reloadWaitingTime,
                reloadType: newWeapon.reloadType,
                showingSound: newWeapon.showingSound,
                firingSound: newWeapon.firingSound,
                reloadingSound: newWeapon.reloadingSound,
                noBulletsSound: newWeapon.noBulletsSound
            )
        )
        onCompleted(response)
    }
}
