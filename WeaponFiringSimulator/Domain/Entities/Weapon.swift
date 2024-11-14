//
//  Weapon.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

enum ReloadType {
    case manual
    case auto
}

struct Weapon {
    let id: Int
    let isDefault: Bool
    let weaponImageName: String
    let bulletsCountImageBaseName: String
    let capacity: Int
    let reloadWaitingTime: TimeInterval
    let reloadType: ReloadType
    let showingSound: SoundType
    let firingSound: SoundType
    let reloadingSound: SoundType
    let noBulletsSound: SoundType?
}
