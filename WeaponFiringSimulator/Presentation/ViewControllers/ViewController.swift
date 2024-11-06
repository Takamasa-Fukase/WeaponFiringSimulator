//
//  ViewController.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 3/11/24.
//

import UIKit

class ViewController: UIViewController {
    var soundPlayer: SoundPlayerInterface!
    let presenter = Presenter()
    
    @IBOutlet weak var weaponImageView: UIImageView!
    @IBOutlet weak var bulletsCountImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundPlayer = SoundPlayer()
        presenter.view = self
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

extension ViewController {
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
