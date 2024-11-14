//
//  WeaponDetailData.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 14/11/24.
//

import Foundation

struct CurrentWeaponData {
    let id: Int
    let weaponImageName: String
    let bulletsCountImageBaseName: String
    let capacity: Int
    let reloadWaitingTime: TimeInterval
    let reloadType: ReloadType
    let showingSound: SoundType
    let firingSound: SoundType
    let reloadingSound: SoundType
    let noBulletsSound: SoundType?
    
    var bulletsCount: Int
    var isReloading: Bool
    
    func bulletsCountImageName() -> String {
        return bulletsCountImageBaseName + String(bulletsCount)
    }
}
