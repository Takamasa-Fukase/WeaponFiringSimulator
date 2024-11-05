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
    var currentWeapon: AnyWeaponType
    
    init() {
        weaponFireUseCase = WeaponFireUseCase()
        weaponReloadUseCase = WeaponReloadUseCase()
        weaponChangeUseCase = WeaponChangeUseCase()
        currentWeapon = Pistol(bulletsCount: 7, isReloading: false)
    }

    func viewDidLoad() {
        showWeapon()
    }
        
    func fireButtonTapped() {
        weaponFireUseCase.execute(
            weapon: currentWeapon,
            onFired: { (firedWeapon, needsAutoReload) in
                currentWeapon = firedWeapon
                view?.playFireSound(type: firedWeapon.firingSound)
                view?.showBulletsCountImage(name: firedWeapon.bulletsCountImageBaseName + String(firedWeapon.bulletsCount))
                if needsAutoReload {
                    // リロードを自動的に実行
                    reloadButtonTapped()
                }
            },
            onCanceled: {
                if let noBulletsSound = currentWeapon.noBulletsSound {
                    view?.playNoBulletsSound(type: noBulletsSound)
                }
            }
        )
    }
    
    func reloadButtonTapped() {
        weaponReloadUseCase.execute(
            weapon: currentWeapon,
            onReloadStarted: { reloadingWeapon in
                currentWeapon = reloadingWeapon
                view?.playReloadSound(type: reloadingWeapon.reloadingSound)
            },
            onReloadEnded: { [weak self] reloadedWeapon in
                self?.currentWeapon = reloadedWeapon
                self?.view?.showBulletsCountImage(name: reloadedWeapon.bulletsCountImageBaseName + String(reloadedWeapon.bulletsCount))
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
        view?.showWeaponImage(name: currentWeapon.weaponImageName)
        view?.showBulletsCountImage(name: currentWeapon.bulletsCountImageBaseName + String(currentWeapon.bulletsCount))
        view?.playShowingSound(type: currentWeapon.showingSound)
    }
}
