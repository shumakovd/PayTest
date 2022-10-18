//
//  CurrencyCVCell.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import UIKit

class CurrencyCVCell: BasicCVCell {

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    
    private var currencyLabel: String = ""
    private var currencyCount: String = ""

    // MARK: - Lifecycle

    override class var cellIdentifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods

    func configureCell(balance: WalletML) {
        currencyLabel = balance.currency?.rawValue ?? ""        
        currencyCount = String(format: "%.2f", balance.amount ?? 0.0)
        
        titleSetup()
    }

    // MARK: - Private Methods

    private func titleSetup() {
        titleLabel.text = "\(currencyCount) \(currencyLabel)"
    }

}
