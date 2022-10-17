//
//  CurrencyConverterHeaderTVCell.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import UIKit

class CurrencyConverterHeaderTVCell: BasicTVCell {
    
    // MARK: - IBOutlets

    @IBOutlet var headerLabel: UILabel!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override class var cellIdentifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Methods

    func configureCell(label: String) {
        headerLabel.text = label
    }
}
