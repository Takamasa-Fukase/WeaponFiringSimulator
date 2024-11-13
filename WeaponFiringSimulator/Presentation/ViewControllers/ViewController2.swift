//
//  ViewController2.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 13/11/24.
//

import UIKit

protocol ViewControllerInterface2: AnyObject {
    func showWeaponList()
    func selectInitialItem(at indexPath: IndexPath)
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
    @IBOutlet private weak var weaponListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        soundPlayer = SoundPlayer()
        let weaponRepository = WeaponRepository()
        presenter = Presenter2(
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
        presenter.fireButtonTapped(selectedIndex: selectedIndex())
    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        presenter.reloadButtonTapped(selectedIndex: selectedIndex())
    }
    
    private func setupCollectionView() {
        weaponListCollectionView.delegate = self
        weaponListCollectionView.dataSource = self
        weaponListCollectionView.register(UINib(nibName: "WeaponListCell", bundle: nil), forCellWithReuseIdentifier: "WeaponListCell")
        weaponListCollectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        weaponListCollectionView.allowsMultipleSelection = false
        weaponListCollectionView.allowsSelection = true
    }
    
    private func selectedIndex() -> Int {
        return weaponListCollectionView.indexPathsForSelectedItems?.first?.row ?? 0
    }
    
    private func weaponId() -> Int {
        return presenter.weaponListItems[selectedIndex()].weaponId
    }
}

extension ViewController2: ViewControllerInterface2 {
    func showWeaponList() {
        weaponListCollectionView.reloadData()
    }
    
    func selectInitialItem(at indexPath: IndexPath) {
        weaponListCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        // selectItem()をコードから呼び出した場合はdidSelectItemAtのDelegateメソッドが発火しないので、手動で呼び出す
        collectionView(weaponListCollectionView, didSelectItemAt: indexPath)
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
        presenter.reloadButtonTapped(selectedIndex: selectedIndex())
    }
}

extension ViewController2: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.weaponListItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeaponListCell", for: indexPath) as! WeaponListCell
        let item = presenter.weaponListItems[indexPath.row]
        cell.weaponImageView.image = UIImage(named: item.weaponImageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextWeaponId = presenter.weaponListItems[selectedIndex()].weaponId
        presenter.changeWeaponButtonTapped(nextWeaponId: nextWeaponId)
    }
}
