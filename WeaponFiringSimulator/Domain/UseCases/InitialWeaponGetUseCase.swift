//
//  InitialWeaponGetUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 6/11/24.
//

import Foundation

struct InitialWeaponGetResponse {
    let weaponId: Int
    let weaponImageName: String
    let bulletsCountImageName: String
    let bulletsCount: Int
    let isReloading: Bool
    let showingSound: SoundType
}

protocol InitialWeaponGetUseCaseInterface {
    func execute(onCompleted: ((InitialWeaponGetResponse) -> Void)) throws
}

final class InitialWeaponGetUseCase: InitialWeaponGetUseCaseInterface {
    let weaponRepository: WeaponRepositoryInterface
    
    init(weaponRepository: WeaponRepositoryInterface) {
        self.weaponRepository = weaponRepository
    }
    
    func execute(onCompleted: ((InitialWeaponGetResponse) -> Void)) throws {
        let weapon = try weaponRepository.getFirst()
        let response = InitialWeaponGetResponse(
            weaponId: weapon.id,
            weaponImageName: weapon.weaponImageName,
            bulletsCountImageName: weapon.bulletsCountImageBaseName + String(weapon.capacity),
            bulletsCount: weapon.capacity,
            isReloading: false,
            showingSound: weapon.showingSound
        )
        onCompleted(response)
    }
}
