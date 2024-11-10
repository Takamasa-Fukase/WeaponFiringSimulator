//
//  WeaponListGetUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 8/11/24.
//

import Foundation

struct WeaponListItem: Equatable {
    let weaponId: Int
    let weaponImageName: String
}

struct WeaponListGetResponse {
    let weaponListItems: [WeaponListItem]
}

protocol WeaponListGetUseCaseInterface {
    func execute() -> WeaponListGetResponse
}

final class WeaponListGetUseCase: WeaponListGetUseCaseInterface {
    let weaponRepository: WeaponRepositoryInterface
    
    init(weaponRepository: WeaponRepositoryInterface) {
        self.weaponRepository = weaponRepository
    }
    
    func execute() -> WeaponListGetResponse {
        let weapons = weaponRepository.getAll()
        let weaponListItems = weapons.map { weapon in
            return WeaponListItem(weaponId: weapon.id,
                                  weaponImageName: weapon.weaponImageName)
        }
        return WeaponListGetResponse(weaponListItems: weaponListItems)
    }
}
