//
//  SubscriptionViewController.swift
//  ruler-ios
//
//  Created by Tigran Arsenyan on 11/20/21.
//

import UIKit

class SubscriptionViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let itemsPerRow: CGFloat = 2
    private let rows: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
      top: 5,
      left: 5,
      bottom: 5,
      right: 5)
    
    // cell data
    private let defaultCellData = [
        SubscriptionDefaultCellModel(imageName: "unlimitedImage", title: "Make unlimited\nsnaps"),
        SubscriptionDefaultCellModel(imageName: "premiumImage", title: "Get Premium\ncontent updates"),
        SubscriptionDefaultCellModel(imageName: "lockImage", title: "Remove\nadvertising")]
    private let selectedCellData = SubscriptionSelectedCellModel(title: "Try 3 days for free\nThen 223,00\nRUB/week")
    
    var closeCommand: CommonCommand? // will work when the controller is closed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "\(SubscriptionCellDefault.self)", bundle: nil), forCellWithReuseIdentifier: "\(SubscriptionCellDefault.self)")
        collectionView.register(UINib(nibName: "\(SubscriptionSelectedCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(SubscriptionSelectedCell.self)")

        initUI()
    }
    
    private func initUI() {
        startButton.layer.cornerRadius = 25
    }
    
    
    @IBAction func privacyAction(_ sender: UIButton) {
    }
    
    @IBAction func termsAction(_ sender: UIButton) {
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.closeCommand?.execute()
        }
    }
}

extension SubscriptionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(rows * itemsPerRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // the last black cell
        if indexPath.row == 3 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionSelectedCell", for: indexPath) as? SubscriptionSelectedCell else { fatalError("Can't load selected cell") }
            
            cell.setData(selectedCellData)
            cell.layer.cornerRadius = 15
            cell.backgroundColor = .black
            print("CELL WIDTH \(cell.bounds.width)")
            return cell
        }
        
        // default cells
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCellDefault", for: indexPath) as? SubscriptionCellDefault else { fatalError("Can't find the SubscriptionCellDefault cell") }

        cell.setData(defaultCellData[indexPath.row])
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
}

extension SubscriptionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthPerItem = (collectionView.frame.width - (sectionInsets.left * (itemsPerRow + 2))) / itemsPerRow
        let heightPerItem = (collectionView.frame.height - (sectionInsets.top * (rows + 1))) / rows
        
        return CGSize(width: widthPerItem - 1, height: heightPerItem)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
