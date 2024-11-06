//
//  WeaponChangeUseCaseMock.swift
//  WeaponFiringSimulatorTests
//
//  Created by ウルトラ深瀬 on 6/11/24.
//

import Foundation
@testable import WeaponFiringSimulator

final class WeaponChangeUseCaseMock: WeaponChangeUseCaseInterface {
    func execute(
        request: WeaponChangeRequest,
        onCompleted: ((WeaponChangeResponse) -> Void)
    ) throws {
        let response = WeaponChangeResponse(
            weaponType: .pistol,
            weaponImageName: "",
            bulletsCountImageBaseName: "",
            bulletsCount: 0,
            isReloading: false,
            showingSound: .pistolSet
        )
        onCompleted(response)
    }
}
