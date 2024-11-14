//
//  WeaponDetailGetUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

struct WeaponDetailGetRequest {
    let weaponId: Int
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

protocol WeaponDetailGetUseCaseInterface {
    func execute(request: WeaponDetailGetRequest) throws -> WeaponDataModel
}

final class WeaponDetailGetUseCase: WeaponDetailGetUseCaseInterface {
    let weaponRepository: WeaponRepositoryInterface
    
    init(weaponRepository: WeaponRepositoryInterface) {
        self.weaponRepository = weaponRepository
    }
    
    func execute(request: WeaponDetailGetRequest) throws -> WeaponDataModel {
        let weapon = try weaponRepository.get(by: request.weaponId)
        return WeaponDataModel(
            id: weapon.id,
            weaponImageName: weapon.weaponImageName,
            bulletsCountImageBaseName: weapon.bulletsCountImageBaseName,
            capacity: weapon.capacity,
            reloadWaitingTime: weapon.reloadWaitingTime,
            reloadType: weapon.reloadType,
            showingSound: weapon.showingSound,
            firingSound: weapon.firingSound,
            reloadingSound: weapon.reloadingSound,
            noBulletsSound: weapon.noBulletsSound
        )
    }
}
