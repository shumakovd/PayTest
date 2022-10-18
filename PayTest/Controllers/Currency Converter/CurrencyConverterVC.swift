//
//  CurrencyConverterVC.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import UIKit
import DropDown

protocol CurrencyExchange: AnyObject {
    func changeCurrencyForSell(currency: Currency, sender: UIButton)
    func changeCurrencyForRecieve(currency: Currency, sender: UIButton)
}

enum ExchangeType {
    case sell, recieve
}

class CurrencyConverterVC: BasicVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    
    private var myBalance: [WalletML] = []
    private var actualAmountOfCurrency: Double = 0.0
    
    private var currencySell: Currency = .EUR {
        didSet(oldValue) {
            if currencySell == currencyRecieve {
                currencyRecieve = oldValue
            }
        }
    }
    private var currencyRecieve: Currency = .USD {
        didSet(oldValue) {
            if currencyRecieve == currencySell {
                currencySell = oldValue
            }
        }
    }
        
    private let currencyListDropDown = DropDown()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup
        setupTableView()
        //
        loadData()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        CurrencyTVCell.registerForTableView(aTableView: tableView)
        CurrencySellTVCell.registerForTableView(aTableView: tableView)
        CurrencyRecieveTVCell.registerForTableView(aTableView: tableView)
        CurrencyConverterHeaderTVCell.registerForTableView(aTableView: tableView)
    }
    
    private func loadData() {        
        myBalance = AppSettings.shared.getBalance()
        //
        tableView.reloadData()
    }
    
    // MARK: - API Methods
    
    private func howMuchCurrencyEqualsChecking(amount: Double) {
        APIManager.shared().getCurrencyAmount(fromAmount: amount, fromCurrency: currencySell, toCurrency: currencyRecieve) { [weak self] (_ result: APIManager.Result<ExchangeML>) in
            guard let strongSelf = self else { return }
            
            switch result {
            case let .success(data):
                let amount = Double(data.amount ?? "") ?? 0.0
                strongSelf.actualAmountOfCurrency = amount
                
            case let .failure(error):
                // Alert
                print("error: ", error)
            }
        }
    }
    
    
    
    
    // MARK: - Drop Down
    
    private func setupCurrencyListDropDown(dropDown: DropDown) {
        dropDown.backgroundColor = UIColor(named: "colorMB") ?? #colorLiteral(red: 0.1180000007, green: 0.1180000007, blue: 0.1180000007, alpha: 1)
        dropDown.setupCornerRadius(12)
        dropDown.cellHeight = 24
        dropDown.shadowColor = .clear
        dropDown.direction = .bottom
        dropDown.dismissMode = .onTap
        dropDown.cellNib = UINib(nibName: "CurrencyTypeTVCell", bundle: nil)
    }

    private func openCurrencyListDropDown(type: ExchangeType, sender: UIButton) {
        view.endEditing(true)
        setupCurrencyListDropDown(dropDown: currencyListDropDown)
        //
        let dataSource = AppSettings.currencies.compactMap({$0.rawValue})
        currencyListDropDown.dataSource = dataSource
        // modify frame, size, etc
        currencyListDropDown.anchorView = sender
        
        currencyListDropDown.show()
        currencyListDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? CurrencyTypeTVCell else { return }
            
            switch type {
            case .sell:
                cell.isUserInteractionEnabled = item != self.currencySell.rawValue
                cell.statusLabel.text = item == self.currencySell.rawValue ? "•" : ""
            case .recieve:
                cell.isUserInteractionEnabled = item != self.currencyRecieve.rawValue
                cell.statusLabel.text = item == self.currencyRecieve.rawValue ? "•" : ""
            }
        }
        
        currencyListDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let strongSelf = self else { return }
            
            switch type {
            case .sell:
                for each in AppSettings.currencies {
                    if each.rawValue == item {
                        strongSelf.currencySell = each
                    }
                }
            case .recieve:
                
                for each in AppSettings.currencies {
                    if each.rawValue == item {
                        strongSelf.currencyRecieve = each
                    }
                }
            }
            
            print("Index: ", index)
            
            strongSelf.tableView.reloadData()
            strongSelf.currencyListDropDown.hide()
        }
    }
    
    // UITextField View When the Keyboard Appears

    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.3, animations: {
                self.submitButton.layer.transform = CATransform3DMakeTranslation(0, -keyboardHeight, 0)
            })
        }
    }
    
    override func keyboardWillHide(notification _: NSNotification) {
        submitButton.layer.transform = CATransform3DIdentity
    }

    
    // MARK: - IBActions
    
    @IBAction private func submitAction(_ sender: UIButton) {
        sender.bounce()
        
//        startIndicator()
//        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
//            self.stopIndicator()
//        }
    }

}

// MARK: - Extensions

// MARK: - CurrencyExchange

extension CurrencyConverterVC: CurrencyExchange {
    func changeCurrencyForSell(currency: Currency, sender: UIButton) {
        openCurrencyListDropDown(type: .sell, sender: sender)
    }
    
    func changeCurrencyForRecieve(currency: Currency, sender: UIButton) {
        openCurrencyListDropDown(type: .recieve, sender: sender)
    }
}

extension CurrencyConverterVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let components = string.components(separatedBy: UITextField.allowedNumberCharacters)
        let filtered = components.joined(separator: "")
        
        let count = textField.text?.count ?? 0
        // need set max and min amount
        if count > 12 {
            textField.deleteBackward()
        }
        
        howMuchCurrencyEqualsChecking(amount: Double(filtered) ?? 0.020)
        
        return string == filtered ? true : false
        
    }
}

// MARK: - TableView Delegate

extension CurrencyConverterVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 36
        case 1:
            return 64
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTVCell.cellIdentifier, for: indexPath) as? CurrencyTVCell else { return UITableViewCell() }
            let sortedBalance = myBalance.sorted(by: {$0.amount ?? 0.0 > $1.amount ?? 0.0})            
            cell.configureCell(balance: sortedBalance)
            
            return cell
        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencySellTVCell.cellIdentifier, for: indexPath) as? CurrencySellTVCell else { return UITableViewCell() }
                cell.configureUI(currency: currencySell, delegate: self)
                cell.amountTextField.delegate = self
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyRecieveTVCell.cellIdentifier, for: indexPath) as? CurrencyRecieveTVCell else { return UITableViewCell() }
                cell.configureUI(currency: currencyRecieve, delegate: self)
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
        
    // HEADER
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyConverterHeaderTVCell.cellIdentifier) as? CurrencyConverterHeaderTVCell else { return nil }
        
        switch section {
        case 0:
            cell.configureCell(label: "MY BALANCE")
            return cell
        case 1:
            cell.configureCell(label: "CURRENCY EXCHANGE")
            return cell
            
        default:
            return nil
        }
    }
    
    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0, 1:
            return 24
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
}
