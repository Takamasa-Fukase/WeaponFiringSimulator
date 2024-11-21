//
//  WeaponResourceGetUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 14/11/24.
//

import Foundation

protocol WeaponResourceGetUseCaseInterface {
    func getWeaponListItems() -> [WeaponListItem]
    func getDefaultWeaponDetail() throws -> CurrentWeaponData
    func getWeaponDetail(of weaponId: Int) throws -> CurrentWeaponData
}

final class WeaponResourceGetUseCase {
    let weaponRepository: WeaponRepositoryInterface
    
    init(weaponRepository: WeaponRepositoryInterface) {
        self.weaponRepository = weaponRepository
    }
}

extension WeaponResourceGetUseCase: WeaponResourceGetUseCaseInterface {
    func getWeaponListItems() -> [WeaponListItem] {
        let weapons = weaponRepository.getAll()
        return weapons.map { weapon in
            return WeaponListItem(weaponId: weapon.id,
                                  weaponImageName: weapon.weaponImageName)
        }
    }
    
    func getDefaultWeaponDetail() throws -> CurrentWeaponData {
        let weapon = try weaponRepository.getDefault()
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
    
    func getWeaponDetail(of weaponId: Int) throws -> CurrentWeaponData {
        let weapon = try weaponRepository.get(by: weaponId)
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
