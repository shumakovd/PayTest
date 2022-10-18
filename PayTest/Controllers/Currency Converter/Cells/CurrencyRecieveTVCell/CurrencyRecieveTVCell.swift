//
//  CurrencyRecieveTVCell.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import UIKit

class CurrencyRecieveTVCell: BasicTVCell {

    // MARK: - IBOutlets

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    // MARK: - Properties
    
    private weak var delegate: CurrencyExchange?
    private var actualAmountOfCurrency: Double = 0.0
    private var currencyString: String = ""
            
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: - Public Methods

    func configureCell(currency: NamesofCurrencies, actualAmountOfCurrency: Double, delegate: CurrencyExchange?) {
        currencyString = currency.rawValue
        self.actualAmountOfCurrency = actualAmountOfCurrency
        self.delegate = delegate
        
        configureUI()
    }
    
    // MARK: - Private Methods
    
    private func configureUI() {
        self.currencyLabel.text = currencyString
        if actualAmountOfCurrency == 0.0 {
            self.amountLabel.text = ""
        } else {
            self.amountLabel.text = String(format: "%.2f", actualAmountOfCurrency)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction private func changeCurrencyAction(_ sender: UIButton) {
        delegate?.changeCurrencyForSellOrRecieve(type: .recieve,sender: sender)
    }
}
