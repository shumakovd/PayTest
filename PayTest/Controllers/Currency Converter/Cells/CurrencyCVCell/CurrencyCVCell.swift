//
//  CurrencyCVCell.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import UIKit

class CurrencyCVCell: BasicCVCell {

    // MARK: - IBOutlets

    @IBOutlet private var titleLabel: UILabel!

    // MARK: - Lifecycle

    override class var cellIdentifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public Methods

    func configureCell(currency: Currency) {
        titleLabel.text = "\(Double(.random(in: 0 ... 1000))) \(currency.rawValue)"
    }

    // MARK: - Private Methods

//    private func setupTagsCollectionView() {
//
//    }

}
