//
//  WeaponResourceGetUseCase.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 14/11/24.
//

import Foundation

public protocol WeaponResourceGetUseCaseInterface {
    func getWeaponListItems() -> [WeaponListItem]
    func getDefaultWeaponDetail() throws -> CurrentWeaponData
    func getWeaponDetail(of weaponId: Int) throws -> CurrentWeaponData
}

public final class WeaponResourceGetUseCase {
    private let weaponRepository: WeaponRepositoryInterface
    
    public init(weaponRepository: WeaponRepositoryInterface) {
        self.weaponRepository = weaponRepository
    }
}

extension WeaponResourceGetUseCase: WeaponResourceGetUseCaseInterface {
    public func getWeaponListItems() -> [WeaponListItem] {
        let weapons = weaponRepository.getAll()
        return weapons.map { weapon in
            return WeaponListItem(weaponId: weapon.id,
                                  weaponImageName: weapon.weaponImageName)
        }
    }
    
    public func getDefaultWeaponDetail() throws -> CurrentWeaponData {
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
    
    public func getWeaponDetail(of weaponId: Int) throws -> CurrentWeaponData {
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
