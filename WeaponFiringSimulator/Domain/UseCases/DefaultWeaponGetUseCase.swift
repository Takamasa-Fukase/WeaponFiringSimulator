//
//  DefaultWeaponGetUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 14/11/24.
//

import Foundation

protocol DefaultWeaponGetUseCaseInterface {
    func execute() throws -> WeaponDataModel
}

final class DefaultWeaponGetUseCase: DefaultWeaponGetUseCaseInterface {
    let weaponRepository: WeaponRepositoryInterface
    
    init(weaponRepository: WeaponRepositoryInterface) {
        self.weaponRepository = weaponRepository
    }
    
    func execute() throws -> WeaponDataModel {
        let weapon = try weaponRepository.getDefault()
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
