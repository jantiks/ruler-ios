//
//  SubscriptionCellDefault.swift
//  ruler-ios
//
//  Created by Tigran Arsenyan on 11/21/21.
//

import UIKit

class SubscriptionCellDefault: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    func setData(_ data: SubscriptionDefaultCellModel) {
        imageView.image = UIImage(named: data.imageName)
        titleLabel.text = data.title
    }
}
