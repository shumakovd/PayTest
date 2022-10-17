//
//  CurrencySellTVCell.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import UIKit

class CurrencySellTVCell: BasicTVCell {

    // MARK: - IBOutlets

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    // MARK: - Properties
    
    private weak var delegate: CurrencyExchange?
    
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

    func configureUI(currency: Currency, delegate: CurrencyExchange?) {
        currencyLabel.text = currency.rawValue
        self.delegate = delegate
    }
    
    // MARK: - IBActions
    
    @IBAction private func changeCurrencyAction(_: UIButton) {
        delegate?.changeCurrency()
    }
    
}
