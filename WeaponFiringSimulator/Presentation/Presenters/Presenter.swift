//
//  Presenter.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

class Presenter {
    let initialWeaponGetUseCase: InitialWeaponGetUseCase
    let weaponFireUseCase: WeaponFireUseCase
    let weaponReloadUseCase: WeaponReloadUseCase
    let weaponChangeUseCase: WeaponChangeUseCase
    weak var view: ViewController?
    var weaponType: WeaponType = .pistol
    var bulletsCount: Int = 0
    var isReloading: Bool = false
    
    init() {
        initialWeaponGetUseCase = InitialWeaponGetUseCase(weaponRepository: WeaponRepository())
        weaponFireUseCase = WeaponFireUseCase(weaponRepository: WeaponRepository())
        weaponReloadUseCase = WeaponReloadUseCase(weaponRepository: WeaponRepository())
        weaponChangeUseCase = WeaponChangeUseCase(weaponRepository: WeaponRepository())
    }

    func viewDidLoad() {
        do {
            try initialWeaponGetUseCase.execute(
                onCompleted: { response in
                    weaponType = response.weaponType
                    bulletsCount = response.bulletsCount
                    isReloading = response.isReloading
                    showWeapon(weaponImageName: response.weaponImageName,
                               bulletsCountImageName: response.bulletsCountImageBaseName + String(response.bulletsCount),
                               showingSound: response.showingSound
                    )
                }
            )
        } catch {
            print("initialWeaponGetUseCase error: \(error)")
        }
    }
        
    func fireButtonTapped() {
        let request = WeaponFireRequest(
            weaponType: weaponType,
            bulletsCount: bulletsCount,
            isReloading: isReloading
        )
        do {
            try weaponFireUseCase.execute(
                request: request,
                onFired: { response in
                    bulletsCount = response.bulletsCount
                    view?.playFireSound(type: response.firingSound)
                    view?.showBulletsCountImage(name: response.bulletsCountImageBaseName + String(response.bulletsCount))
                    
                    if response.needsAutoReload {
                        // リロードを自動的に実行
                        reloadButtonTapped()
                    }
                },
                onCanceled: { response in
                    if let noBulletsSound = response.noBulletsSound {
                        view?.playNoBulletsSound(type: noBulletsSound)
                    }
                }
            )
        } catch {
            print("weaponFireUseCase error: \(error)")
        }
    }
    
    func reloadButtonTapped() {
        let request = WeaponReloadRequest(
            weaponType: weaponType,
            bulletsCount: bulletsCount,
            isReloading: isReloading
        )
        do {
            try weaponReloadUseCase.execute(
                request: request,
                onReloadStarted: { response in
                    view?.playReloadSound(type: response.reloadingSound)
                    isReloading = response.isReloading
                },
                onReloadEnded: { [weak self] response in
                    self?.bulletsCount = response.bulletsCount
                    self?.isReloading = response.isReloading
                    self?.view?.showBulletsCountImage(name: response.bulletsCountImageBaseName + String(response.bulletsCount))
                }
            )
        } catch {
            print("weaponReloadUseCase error: \(error)")
        }
    }
    
    func changeWeaponButtonTapped() {
        let request = WeaponChangeRequest(
            weaponType: weaponType
        )
        do {
            try weaponChangeUseCase.execute(
                request: request,
                onCompleted: { response in
                    weaponType = response.weaponType
                    bulletsCount = response.bulletsCount
                    isReloading = response.isReloading
                    showWeapon(weaponImageName: response.weaponImageName,
                               bulletsCountImageName: response.bulletsCountImageBaseName + String(response.bulletsCount),
                               showingSound: response.showingSound
                    )
                }
            )
        } catch {
            print("weaponChangeUseCase error: \(error)")
        }
    }
    
    private func showWeapon(weaponImageName: String, bulletsCountImageName: String, showingSound: SoundType) {
        view?.showWeaponImage(name: weaponImageName)
        view?.showBulletsCountImage(name: bulletsCountImageName)
        view?.playShowingSound(type: showingSound)
    }
}
