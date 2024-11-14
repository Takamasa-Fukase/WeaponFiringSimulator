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

protocol WeaponDetailGetUseCaseInterface {
    func execute(request: WeaponDetailGetRequest) throws -> CurrentWeaponData
}

final class WeaponDetailGetUseCase: WeaponDetailGetUseCaseInterface {
    let weaponRepository: WeaponRepositoryInterface
    
    init(weaponRepository: WeaponRepositoryInterface) {
        self.weaponRepository = weaponRepository
    }
    
    func execute(request: WeaponDetailGetRequest) throws -> CurrentWeaponData {
        let weapon = try weaponRepository.get(by: request.weaponId)
        return CurrentWeaponData(
            id: weapon.id,
            weaponImageName: weapon.weaponImageName,
            bulletsCountImageBaseName: weapon.bulletsCountImageBaseName,
            capacity: weapon.capacity,
            reloadWaitingTime: weapon.reloadWaitingTime,
            reloadType: weapon.reloadType,
            showingSound: weapon.showingSound,
            firingSound: weapon.firingSound,
            reloadingSound: weapon.reloadingSound,
            noBulletsSound: weapon.noBulletsSound,
            bulletsCount: weapon.capacity,
            isReloading: false
        )
    }
}
