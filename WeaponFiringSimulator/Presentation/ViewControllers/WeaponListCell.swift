//
//  WeaponListCell.swift
//  WeaponFiringSimulator
//
//  Created by ウルトラ深瀬 on 8/11/24.
//

import UIKit

class WeaponListCell: UICollectionViewCell {

    @IBOutlet weak var weaponImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                weaponImageView.layer.borderColor = UIColor.systemGreen.cgColor
                weaponImageView.layer.borderWidth = 4
            }else {
                weaponImageView.layer.borderColor = UIColor.clear.cgColor
                weaponImageView.layer.borderWidth = 0
            }
        }
    }
}
