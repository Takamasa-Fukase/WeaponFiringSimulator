//
//  RepositoryFactory.swift
//  Sample_AR-GunMan_Replace
//
//  Created by ウルトラ深瀬 on 19/11/24.
//

import Foundation
import Data

public final class RepositoryFactory {
    public static func makeWeaponRepository() -> WeaponRepository {
        return .init()
    }
}
