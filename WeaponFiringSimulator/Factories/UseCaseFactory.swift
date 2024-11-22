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
    public static func create() -> WeaponResourceGetUseCaseInterface {
        return WeaponResourceGetUseCase(weaponRepository: RepositoryFactory.create())
    }
    
    public static func create() -> WeaponStatusCheckUseCaseInterface {
        return WeaponStatusCheckUseCase()
    }
    
    public static func create() -> WeaponActionExecuteUseCaseInterface {
        return WeaponActionExecuteUseCase(weaponStatusCheckUseCase: create())
    }
}
