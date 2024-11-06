//
//  InitialWeaponGetUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 6/11/24.
//

import Foundation

struct InitialWeaponGetResponse {
    let weaponType: WeaponType
    let weaponImageName: String
    let bulletsCountImageBaseName: String
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
        let weapon = try weaponRepository.get(by: .pistol)
        let response = InitialWeaponGetResponse(
            weaponType: weapon.type,
            weaponImageName: weapon.weaponImageName,
            bulletsCountImageBaseName: weapon.bulletsCountImageBaseName,
            bulletsCount: weapon.capacity,
            isReloading: false,
            showingSound: weapon.showingSound
        )
        onCompleted(response)
    }
}
