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

struct WeaponChangeResponse {
    let weaponImageName: String
    let bulletsCountImageName: String
    let bulletsCount: Int
    let isReloading: Bool
    let showingSound: SoundType
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
            weaponImageName: newWeapon.weaponImageName,
            bulletsCountImageName: newWeapon.bulletsCountImageBaseName + String(newWeapon.capacity),
            bulletsCount: newWeapon.capacity,
            isReloading: false,
            showingSound: newWeapon.showingSound
        )
        onCompleted(response)
    }
}
