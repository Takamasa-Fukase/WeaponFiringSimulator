//
//  ViewController.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 3/11/24.
//

import UIKit

protocol ViewControllerInterface: AnyObject {
    func updateWeaponId(_ weaponId: Int)
    func updateBulletsCount(_ bulletsCount: Int)
    func updateReloadingFlag(_ isReloading: Bool)
    func showWeaponImage(name: String)
    func showBulletsCountImage(name: String)
    func playShowingSound(type: SoundType)
    func playFireSound(type: SoundType)
    func playReloadSound(type: SoundType)
    func playNoBulletsSound(type: SoundType)
    func executeAutoReload()
}

final class ViewController: UIViewController {
    private var soundPlayer: SoundPlayerInterface!
    private var presenter: PresenterInterface!
    
    private var weaponId: Int = 0
    private var bulletsCount: Int = 0
    private var isReloading = false
    
    @IBOutlet private weak var weaponImageView: UIImageView!
    @IBOutlet private weak var bulletsCountImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundPlayer = SoundPlayer()
        let weaponRepository = WeaponRepository()
        presenter = Presenter(
            view: self,
            initialWeaponGetUseCase: InitialWeaponGetUseCase(weaponRepository: weaponRepository),
            weaponFireUseCase: WeaponFireUseCase(
                weaponRepository: weaponRepository,
                canFireCheckUseCase: CanFireCheckUseCase(),
                needsAutoReloadCheckUseCase: NeedsAutoReloadCheckUseCase()
            ),
            weaponReloadUseCase: WeaponReloadUseCase(
                weaponRepository: weaponRepository,
                canReloadCheckUseCase: CanReloadCheckUseCase()
            ),
            weaponChangeUseCase: WeaponChangeUseCase(weaponRepository: weaponRepository)
        )
        presenter.viewDidLoad()
    }
    
    @IBAction func fireButtonTapped(_ sender: Any) {
        presenter.fireButtonTapped(weaponId: weaponId,
                                   bulletsCount: bulletsCount,
                                   isReloading: isReloading)
    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        presenter.reloadButtonTapped(weaponId: weaponId,
                                     bulletsCount: bulletsCount,
                                     isReloading: isReloading)
    }
    
    @IBAction func changeWeaponButtonTapped(_ sender: Any) {
        // TODO: UI上で武器リストを表示して、そのタップ時のindexをnextWeaponIdとして使う様に変更する
        let nextWeaponid: Int = {
            if weaponId == 0 {
                return 1
            }else {
                return 0
            }
        }()
        presenter.changeWeaponButtonTapped(nextWeaponId: nextWeaponid)
    }
}

extension ViewController: ViewControllerInterface {
    func updateWeaponId(_ weaponId: Int) {
        self.weaponId = weaponId
    }
    
    func updateBulletsCount(_ bulletsCount: Int) {
        self.bulletsCount = bulletsCount
    }
    
    func updateReloadingFlag(_ isReloading: Bool) {
        self.isReloading = isReloading
    }
    
    func showWeaponImage(name: String) {
        weaponImageView.image = UIImage(named: name)
    }
    
    func showBulletsCountImage(name: String) {
        bulletsCountImageView.image = UIImage(named: name)
    }
    
    func playShowingSound(type: SoundType) {
        soundPlayer.play(type)
    }
    
    func playFireSound(type: SoundType) {
        soundPlayer.play(type)
    }
    
    func playReloadSound(type: SoundType) {
        soundPlayer.play(type)
    }
    
    func playNoBulletsSound(type: SoundType) {
        soundPlayer.play(type)
    }
    
    func executeAutoReload() {
        presenter.reloadButtonTapped(weaponId: weaponId,
                                     bulletsCount: bulletsCount,
                                     isReloading: isReloading)
    }
}
