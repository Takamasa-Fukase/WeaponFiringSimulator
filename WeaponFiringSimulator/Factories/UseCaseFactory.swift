//
//  UseCaseFactory.swift
//
//
//  Created by ウルトラ深瀬 on 21/11/24.
//

import Foundation
import Data
import Domain

public final class UseCaseFactory {
    public static func makeWeaponResourceGetUseCase() -> WeaponResourceGetUseCase {
        return .init(weaponRepository: RepositoryFactory.makeWeaponRepository())
    }
    
    public static func makeWeaponStatusCheckUseCase() -> WeaponStatusCheckUseCase {
        return .init()
    }
    
    public static func makeWeaponActionExecuteUseCase() -> WeaponActionExecuteUseCase {
        return .init(weaponStatusCheckUseCase: makeWeaponStatusCheckUseCase())
    }
}
