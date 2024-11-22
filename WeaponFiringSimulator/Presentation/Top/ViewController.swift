//
//  ViewController.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 13/11/24.
//

import UIKit
import Domain
import Data

public protocol ViewControllerInterface: AnyObject {
    func inject(soundPlayer: SoundPlayerInterface, presenter: PresenterInterface)
    func showWeaponImage(name: String)
    func showBulletsCountImage(name: String)
    func playSound(type: SoundType)
    func executeAutoReload()
}

public final class ViewController: UIViewController {
    private var soundPlayer: SoundPlayerInterface!
    private var presenter: PresenterInterface!

    @IBOutlet private weak var weaponImageView: UIImageView!
    @IBOutlet private weak var bulletsCountImageView: UIImageView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
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

extension ViewController: ViewControllerInterface {
    public func inject(soundPlayer: SoundPlayerInterface, presenter: PresenterInterface) {
        self.soundPlayer = soundPlayer
        self.presenter = presenter
    }

    public func showWeaponImage(name: String) {
        weaponImageView.image = UIImage(named: name)
    }
    
    public func showBulletsCountImage(name: String) {
        bulletsCountImageView.image = UIImage(named: name)
    }
    
    public func playSound(type: SoundType) {
        soundPlayer.play(type)
    }
    
    public func executeAutoReload() {
        presenter.reloadButtonTapped()
    }
}
