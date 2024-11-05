//
//  Presenter.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

class Presenter {
    let weaponFireUseCase: WeaponFireUseCase
    let weaponReloadUseCase: WeaponReloadUseCase
    let weaponChangeUseCase: WeaponChangeUseCase
    weak var view: ViewController?
    var currentWeapon: Weapon
    
    init() {
        weaponFireUseCase = WeaponFireUseCase()
        weaponReloadUseCase = WeaponReloadUseCase()
        weaponChangeUseCase = WeaponChangeUseCase()
        currentWeapon = .init(
            type: .pistol,
            imageName: "pistol",
            capacity: 7,
            reloadWaitingTime: 0,
            bulletsCount: 7,
            isReloading: false,
            reloadType: .manual
        )
    }

    func viewDidLoad() {
        showWeapon()
    }
        
    func fireButtonTapped() {
        weaponFireUseCase.execute(
            weapon: currentWeapon,
            onFired: { (firedWeapon, needsAutoReload) in
                currentWeapon = firedWeapon
                view?.playFireSound(type: firedWeapon.type)
                view?.showBulletsCountImage(type: firedWeapon.type,
                                            count: firedWeapon.bulletsCount)
                if needsAutoReload {
                    // リロードを自動的に実行
                    reloadButtonTapped()
                }
            },
            onCanceled: {
                view?.playNoBulletsSound(type: currentWeapon.type)
            }
        )
    }
    
    func reloadButtonTapped() {
        weaponReloadUseCase.execute(
            weapon: currentWeapon,
            onReloadStarted: { reloadingWeapon in
                currentWeapon = reloadingWeapon
                view?.playReloadSound(type: reloadingWeapon.type)
            },
            onReloadEnded: { [weak self] reloadedWeapon in
                self?.currentWeapon = reloadedWeapon
                self?.view?.showBulletsCountImage(type: reloadedWeapon.type,
                                            count: reloadedWeapon.bulletsCount)
            }
        )
    }
    
    func changeWeaponButtonTapped() {
        weaponChangeUseCase.execute(
            weapon: currentWeapon,
            onCompleted: { newWeapon in
                currentWeapon = newWeapon
                showWeapon()
            }
        )
    }
    
    private func showWeapon() {
        view?.showWeaponImage(type: currentWeapon.type)
        view?.showBulletsCountImage(type: currentWeapon.type,
                                    count: currentWeapon.bulletsCount)
        view?.playShowingSound(type: currentWeapon.type)
    }
}
