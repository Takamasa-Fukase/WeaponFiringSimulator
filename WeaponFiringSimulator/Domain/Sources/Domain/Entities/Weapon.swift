//
//  Weapon.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

public enum ReloadType {
    case manual
    case auto
}

public struct Weapon {
    public let id: Int
    public let isDefault: Bool
    public let weaponImageName: String
    public let bulletsCountImageBaseName: String
    public let capacity: Int
    public let reloadWaitingTime: TimeInterval
    public let reloadType: ReloadType
    public let showingSound: SoundType
    public let firingSound: SoundType
    public let reloadingSound: SoundType
    public let noBulletsSound: SoundType?
    
    public init(
        id: Int,
        isDefault: Bool,
        weaponImageName: String,
        bulletsCountImageBaseName: String,
        capacity: Int,
        reloadWaitingTime: TimeInterval,
        reloadType: ReloadType,
        showingSound: SoundType,
        firingSound: SoundType,
        reloadingSound: SoundType,
        noBulletsSound: SoundType?
    ) {
        self.id = id
        self.isDefault = isDefault
        self.weaponImageName = weaponImageName
        self.bulletsCountImageBaseName = bulletsCountImageBaseName
        self.capacity = capacity
        self.reloadWaitingTime = reloadWaitingTime
        self.reloadType = reloadType
        self.showingSound = showingSound
        self.firingSound = firingSound
        self.reloadingSound = reloadingSound
        self.noBulletsSound = noBulletsSound
    }
}
