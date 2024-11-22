//
//  RepositoryFactory.swift
//  Sample_AR-GunMan_Replace
//
//  Created by ウルトラ深瀬 on 19/11/24.
//

import Foundation
import Domain
import Data

public final class RepositoryFactory {
    public static func create() -> WeaponRepositoryInterface {
        return WeaponRepository()
    }
}
