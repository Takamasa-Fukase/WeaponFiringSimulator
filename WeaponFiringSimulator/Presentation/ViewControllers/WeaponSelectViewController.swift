//
//  WeaponSelectViewController.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 14/11/24.
//

import UIKit

class WeaponSelectViewController: UIViewController {
    var weaponSelected: ((_ weaponId: Int) -> Void) = { _ in }
    private var weaponListItems: [WeaponListItem] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    init() {
        super.init(nibName: "WeaponSelectViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weaponListItems = WeaponListGetUseCase(weaponRepository: WeaponRepository()).execute().weaponListItems
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "WeaponListCell", bundle: nil), forCellWithReuseIdentifier: "WeaponListCell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = true
    }
    
    private func selectedIndex() -> Int {
        return collectionView.indexPathsForSelectedItems?.first?.row ?? 0
    }
    
    private func weaponId() -> Int {
        return weaponListItems[selectedIndex()].weaponId
    }
    
    func showWeaponList() {
        collectionView.reloadData()
    }
    
    func selectInitialItem(at indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        // selectItem()をコードから呼び出した場合はdidSelectItemAtのDelegateメソッドが発火しないので、手動で呼び出す
        collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
}

extension WeaponSelectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weaponListItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeaponListCell", for: indexPath) as! WeaponListCell
        let item = weaponListItems[indexPath.row]
        cell.weaponImageView.image = UIImage(named: item.weaponImageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextWeaponId = weaponListItems[indexPath.row].weaponId
        weaponSelected(nextWeaponId)
        dismiss(animated: true)
    }
}

extension WeaponSelectViewController: UICollectionViewDelegateFlowLayout {
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
