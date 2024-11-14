//
//  ViewController2.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 13/11/24.
//

import UIKit

protocol ViewControllerInterface2: AnyObject {
    func showWeaponImage(name: String)
    func showBulletsCountImage(name: String)
    func playShowingSound(type: SoundType)
    func playFireSound(type: SoundType)
    func playReloadSound(type: SoundType)
    func playNoBulletsSound(type: SoundType)
    func executeAutoReload()
}

final class ViewController2: UIViewController {
    private var soundPlayer: SoundPlayerInterface!
    private var presenter: PresenterInterface2!

    @IBOutlet private weak var weaponImageView: UIImageView!
    @IBOutlet private weak var bulletsCountImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundPlayer = SoundPlayer()
        let weaponRepository = WeaponRepository()
        presenter = Presenter2(
            view: self,
            defaultWeaponGetUseCase: DefaultWeaponGetUseCase(weaponRepository: weaponRepository),
            weaponDetailGetUseCase: WeaponDetailGetUseCase(weaponRepository: weaponRepository),
            weaponFireUseCase: WeaponFireUseCase(
                weaponRepository: weaponRepository,
                canFireCheckUseCase: CanFireCheckUseCase(),
                needsAutoReloadCheckUseCase: NeedsAutoReloadCheckUseCase()
            ),
            weaponReloadUseCase: WeaponReloadUseCase(
                weaponRepository: weaponRepository,
                canReloadCheckUseCase: CanReloadCheckUseCase()
            )
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
        let vc = WeaponSelectViewController()
        
        vc.weaponSelected = { [weak self] weaponId in
            self?.presenter.weaponSelected(weaponId: weaponId)
        }
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    context.maximumDetentValue * 0.4
                })
            ]
        }
        present(vc, animated: true)
    }
}

extension ViewController2: ViewControllerInterface2 {
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
        presenter.reloadButtonTapped()
    }
}
