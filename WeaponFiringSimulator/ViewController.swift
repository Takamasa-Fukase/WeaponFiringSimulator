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
    func showWeaponImage(type: WeaponType) {
        switch type {
        case .pistol:
            weaponImageView.image = UIImage(named: "pistol")
        case .bazooka:
            weaponImageView.image = UIImage(named: "bazooka")
        }
    }
    
    func showBulletsCountImage(type: WeaponType, count: Int) {
        switch type {
        case .pistol:
            bulletsCountImageView.image = UIImage(named: "bullets\(count)")
        case .bazooka:
            bulletsCountImageView.image = UIImage(named: "bazookaRocket\(count)")
        }
    }
    
    func playShowingSound(type: WeaponType) {
        switch type {
        case .pistol:
            soundPlayer.play(.pistolSet)
        case .bazooka:
            soundPlayer.play(.bazookaSet)
        }
    }
    
    func playFireSound(type: WeaponType) {
        switch type {
        case .pistol:
            soundPlayer.play(.pistolShoot)
        case .bazooka:
            soundPlayer.play(.bazookaShoot)
        }
    }
    
    func playReloadSound(type: WeaponType) {
        switch type {
        case .pistol:
            soundPlayer.play(.pistolReload)
        case .bazooka:
            soundPlayer.play(.bazookaReload)
        }
    }
    
    func playNoBulletsSound(type: WeaponType) {
        switch type {
        case .pistol:
            soundPlayer.play(.pistolOutBullets)
        case .bazooka:
            break
        }
    }
}
