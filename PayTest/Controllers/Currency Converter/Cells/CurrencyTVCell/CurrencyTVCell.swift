//
//  CurrencyTVCell.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import UIKit

class CurrencyTVCell: BasicTVCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    private var balance: [WalletML] = []

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    override class var cellIdentifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    
    func configureCell(wallet: [WalletML]) {
        self.balance = wallet
        
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 20, height: 36)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        // layout.minimumInteritemSpacing = 8
        // layout.minimumLineSpacing = 5
        collectionView.collectionViewLayout = layout
        
        CurrencyCVCell.registerForCollectionView(aCollectionView: collectionView)
    }
}

extension CurrencyTVCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return balance.count
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 10
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: 64, height: 36)
    }    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCVCell.cellIdentifier, for: indexPath) as? CurrencyCVCell else { return BasicCVCell() }
        cell.configureCell(currency: balance[indexPath.row].currency ?? .EUR)
        return cell
    }
    
    
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did Select Item With IndexPath: ", indexPath)
    }
    
}
