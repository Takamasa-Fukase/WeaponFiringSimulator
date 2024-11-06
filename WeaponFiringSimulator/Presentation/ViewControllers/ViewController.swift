//
//  ViewController.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 3/11/24.
//

import UIKit

protocol ViewControllerInterface: AnyObject {
    func showWeaponImage(name: String)
    func showBulletsCountImage(name: String)
    func playShowingSound(type: SoundType)
    func playFireSound(type: SoundType)
    func playReloadSound(type: SoundType)
    func playNoBulletsSound(type: SoundType)
}

final class ViewController: UIViewController {
    private var soundPlayer: SoundPlayerInterface!
    private var presenter: PresenterInterface!
    
    @IBOutlet private weak var weaponImageView: UIImageView!
    @IBOutlet private weak var bulletsCountImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundPlayer = SoundPlayer()
        let weaponRepository = WeaponRepository()
        presenter = Presenter(
            view: self,
            initialWeaponGetUseCase: InitialWeaponGetUseCase(weaponRepository: weaponRepository),
            weaponFireUseCase: WeaponFireUseCase(weaponRepository: weaponRepository),
            weaponReloadUseCase: WeaponReloadUseCase(weaponRepository: weaponRepository),
            weaponChangeUseCase: WeaponChangeUseCase(weaponRepository: weaponRepository)
        )
        presenter.viewDidLoad()
    }
    
    @IBAction func fireButtonTapped(_ sender: Any) {
        presenter.fireButtonTapped()
    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        presenter.reloadButtonTapped()
    }
    
    @IBAction func changeWeaponButtonTapped(_ sender: Any) {
        presenter.changeWeaponButtonTapped()
    }
}

extension ViewController: ViewControllerInterface {
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
}
