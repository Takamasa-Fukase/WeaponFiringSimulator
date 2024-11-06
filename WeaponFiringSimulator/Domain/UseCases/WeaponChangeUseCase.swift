//
//  WeaponChangeUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

struct WeaponChangeRequest {
    let weaponType: WeaponType
}

struct WeaponChangeResponse {
    let weaponType: WeaponType
    let weaponImageName: String
    let bulletsCountImageBaseName: String
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
        let newWeaponType: WeaponType = {
            switch request.weaponType {
            case .pistol:
                return .bazooka
            case .bazooka:
                return .pistol
            }
        }()
        let newWeapon = try weaponRepository.get(by: newWeaponType)
        let response = WeaponChangeResponse(
            weaponType: newWeaponType,
            weaponImageName: newWeapon.weaponImageName,
            bulletsCountImageBaseName: newWeapon.bulletsCountImageBaseName,
            bulletsCount: newWeapon.capacity,
            isReloading: false,
            showingSound: newWeapon.showingSound
        )
        onCompleted(response)
    }
}
