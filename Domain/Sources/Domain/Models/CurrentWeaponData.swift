//
//  CurrentWeaponData.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 14/11/24.
//

import Foundation

public struct CurrentWeaponData {
    public let id: Int
    public let weaponImageName: String
    public let bulletsCountImageBaseName: String
    public let capacity: Int
    public let reloadWaitingTime: TimeInterval
    public let reloadType: ReloadType
    public let showingSound: SoundType
    public let firingSound: SoundType
    public let reloadingSound: SoundType
    public let noBulletsSound: SoundType?
    
    public var bulletsCount: Int
    public var isReloading: Bool
    
    public func bulletsCountImageName() -> String {
        return bulletsCountImageBaseName + String(bulletsCount)
    }
}
