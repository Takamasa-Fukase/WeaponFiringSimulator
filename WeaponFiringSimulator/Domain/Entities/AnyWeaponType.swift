//
//  AnyWeaponType.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

enum ReloadType {
    case manual
    case auto
}

protocol AnyWeaponType {
    var weaponImageName: String { get }
    var bulletsCountImageBaseName: String { get }
    var capacity: Int { get }
    var reloadWaitingTime: TimeInterval { get }
    var reloadType: ReloadType { get }
    var showingSound: SoundType { get }
    var firingSound: SoundType { get }
    var reloadingSound: SoundType { get }
    var noBulletsSound: SoundType? { get }
    
    var bulletsCount: Int { get }
    var isReloading: Bool { get }
    
    func canFire(
        bulletsCount: Int,
        isReloading: Bool
    ) -> Bool
    
    func canReload(
        bulletsCount: Int,
        isReloading: Bool
    ) -> Bool
    
    func needsAutoReload(
        bulletsCount: Int,
        isReloading: Bool,
        reloadType: ReloadType
    ) -> Bool
    
    func copyWith(
        bulletsCount: Int,
        isReloading: Bool
    ) -> AnyWeaponType
}

extension AnyWeaponType {
    var noBulletsSound: SoundType? {
        return nil
    }
    
    func canFire(
        bulletsCount: Int,
        isReloading: Bool
    ) -> Bool {
        print("Weapon canFire bulletsCount: \(bulletsCount), isReloading: \(isReloading)")
        if isReloading { return false }
        if bulletsCount > 0 {
            print("canFire return true")
            return true
        }else {
            print("canFire return flase")
            return false
        }
    }
    
    func canReload(
        bulletsCount: Int,
        isReloading: Bool
    ) -> Bool {
        print("Weapon canReload bulletsCount: \(bulletsCount), isReloading: \(isReloading)")
        if isReloading { return false }
        if bulletsCount <= 0 {
            print("canReload return true")
            return true
        }else {
            print("canReload return false")
            return false
        }
    }
    
    func needsAutoReload(
        bulletsCount: Int,
        isReloading: Bool,
        reloadType: ReloadType
    ) -> Bool {
        print("Weapon needsAutoReload bulletsCount: \(bulletsCount), isReloading: \(isReloading), reloadType: \(reloadType)")
        if isReloading { return false }
        if bulletsCount == 0 && reloadType == .auto {
            print("needsAutoReload return true")
            return true
        }else {
            print("needsAutoReload return false")
            return false
        }
    }
    
    func copyWith(
        bulletsCount: Int,
        isReloading: Bool
    ) -> AnyWeaponType {
//        return self.copyWith(bulletsCount: bulletsCount, isReloading: isReloading)
        return self
    }
}

struct Pistol: AnyWeaponType {
    let weaponImageName: String
    let bulletsCountImageBaseName: String
    let capacity: Int
    let reloadWaitingTime: TimeInterval
    let reloadType: ReloadType
    let showingSound: SoundType
    let firingSound: SoundType
    let reloadingSound: SoundType
    let noBulletsSound: SoundType?
    let bulletsCount: Int
    let isReloading: Bool
    
    init(
        bulletsCount: Int,
        isReloading: Bool
    ) {
        self.weaponImageName = "pistol"
        self.bulletsCountImageBaseName = "bullets"
        self.capacity = 7
        self.reloadWaitingTime = 0
        self.reloadType = .manual
        self.showingSound = .pistolSet
        self.firingSound = .pistolShoot
        self.reloadingSound = .pistolReload
        self.noBulletsSound = .pistolOutBullets
        self.bulletsCount = bulletsCount
        self.isReloading = isReloading
    }
}

struct Bazooka: AnyWeaponType {
    let weaponImageName: String
    let bulletsCountImageBaseName: String
    let capacity: Int
    let reloadWaitingTime: TimeInterval
    let reloadType: ReloadType
    let showingSound: SoundType
    let firingSound: SoundType
    let reloadingSound: SoundType
    let bulletsCount: Int
    let isReloading: Bool
    
    init(
        bulletsCount: Int,
        isReloading: Bool
    ) {
        self.weaponImageName = "bazooka"
        self.bulletsCountImageBaseName = "bazookaRocket"
        self.capacity = 1
        self.reloadWaitingTime = 3.2
        self.reloadType = .auto
        self.showingSound = .bazookaSet
        self.firingSound = .bazookaShoot
        self.reloadingSound = .bazookaReload
        self.bulletsCount = bulletsCount
        self.isReloading = isReloading
    }
}
