//
//  SubscriptionCellSelected.swift
//  ruler-ios
//
//  Created by Tigran Arsenyan on 11/21/21.
//

import UIKit

class SubscriptionSelectedCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    
    func setData(_ data: SubscriptionSelectedCellModel) {
        titleLabel.text = data.title
    }
}
