//
//  ViewController.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 3/11/24.
//

import UIKit

protocol ViewControllerInterface: AnyObject {
    func showWeaponList(_ listItems: [WeaponListItem])
    func selectInitialItem(at indexPath: IndexPath)
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
    
    private var bulletsCount: Int = 0
    private var isReloading = false
    private var selectedIndex: Int = 0
    private var weaponListItems: [WeaponListItem] = []
    
    @IBOutlet private weak var weaponImageView: UIImageView!
    @IBOutlet private weak var bulletsCountImageView: UIImageView!
    @IBOutlet private weak var weaponListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        soundPlayer = SoundPlayer()
        let weaponRepository = WeaponRepository()
        presenter = Presenter(
            view: self,
            weaponListGetUseCase: WeaponListGetUseCase(weaponRepository: weaponRepository),
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
        presenter.fireButtonTapped(weaponId: weaponId(),
                                   bulletsCount: bulletsCount,
                                   isReloading: isReloading)
    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        presenter.reloadButtonTapped(weaponId: weaponId(),
                                     bulletsCount: bulletsCount,
                                     isReloading: isReloading)
    }
    
    private func setupCollectionView() {
        weaponListCollectionView.delegate = self
        weaponListCollectionView.dataSource = self
        weaponListCollectionView.register(UINib(nibName: "WeaponListCell", bundle: nil), forCellWithReuseIdentifier: "WeaponListCell")
        weaponListCollectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    private func weaponId() -> Int {
        return weaponListItems[selectedIndex].weaponId
    }
}

extension ViewController: ViewControllerInterface {
    func showWeaponList(_ listItems: [WeaponListItem]) {
        self.weaponListItems = listItems
        weaponListCollectionView.reloadData()
    }
    
    func selectInitialItem(at indexPath: IndexPath) {
        selectedIndex = indexPath.row
        weaponListCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        collectionView(weaponListCollectionView, didSelectItemAt: indexPath)
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
        presenter.reloadButtonTapped(weaponId: weaponId(),
                                     bulletsCount: bulletsCount,
                                     isReloading: isReloading)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weaponListItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeaponListCell", for: indexPath) as! WeaponListCell
        let item = weaponListItems[indexPath.row]
        cell.weaponImageView.image = UIImage(named: item.weaponImageName)
        if indexPath.row == selectedIndex {
            cell.weaponImageView.layer.borderColor = UIColor.systemGreen.cgColor
            cell.weaponImageView.layer.borderWidth = 4
        }else {
            cell.weaponImageView.layer.borderColor = UIColor.clear.cgColor
            cell.weaponImageView.layer.borderWidth = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        weaponListCollectionView.reloadData()
        let nextWeaponId = weaponListItems[selectedIndex].weaponId
        presenter.changeWeaponButtonTapped(nextWeaponId: nextWeaponId)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
