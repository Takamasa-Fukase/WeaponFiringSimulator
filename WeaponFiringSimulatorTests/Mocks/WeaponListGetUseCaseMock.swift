//
//  WeaponListGetUseCaseMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 9/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class WeaponListGetUseCaseMock: WeaponListGetUseCaseInterface {
    func execute() -> WeaponListGetResponse {
        return .init(weaponListItems: [
            .init(
                weaponId: 0,
                weaponImageName: "pistol"
            ),
            .init(
                weaponId: 1,
                weaponImageName: "bazooka"
            )
        ])
    }
}
