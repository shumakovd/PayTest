//
//  CurrencyConverterVC.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import UIKit
import DropDown

enum ExchangeType {
    case sell, recieve
}

protocol CurrencyExchange: AnyObject {
    func changeCurrencyForSellOrRecieve(type: ExchangeType, sender: UIButton)
}

class CurrencyConverterVC: BasicVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    
    private var myBalance: [WalletML] = []
    private var userWantToSell: Double = 0.0
    private var currentFee: Double = 0.0
    private let currencyListDropDown = DropDown()
    private let serialQueue = DispatchQueue(label: "com.serial-queue", qos: .utility)
    
    private var actualAmountOfCurrency: Double = 0.0 {
        willSet {
            if newValue > 0.0 {
                buttonState(state: true, button: submitButton)
            } else {
                buttonState(state: false, button: submitButton)
            }
        }
    }
    private var currencySell: NamesofCurrencies = .EUR {
        didSet(oldValue) {
            if currencySell == currencyRecieve {
                currencyRecieve = oldValue
            }
            howMuchCurrencyEqualsChecking(amount: userWantToSell)
        }
    }
    private var currencyRecieve: NamesofCurrencies = .USD {
        didSet(oldValue) {
            if currencyRecieve == currencySell {
                currencySell = oldValue
            }
            howMuchCurrencyEqualsChecking(amount: userWantToSell)
        }
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup
        setupTableView()
        buttonState(state: false, button: submitButton)
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
    
    private func buttonState(state: Bool, button: UIButton) {
        button.isEnabled = state
        button.alpha = state ? 1 : 0.8
    }
        
    private func checkIfUserHasEnoughtMoney() -> Bool {
        for each in myBalance {
            if each.currency.name == currencySell {
                currentFee = each.currency.fee
                if each.freeFeeExist() {
                    currentFee = 0.0
                }
                if each.isThereEnoughCash(forTheAmount: userWantToSell) {
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
    
    private func currencyConvert(completion: @escaping (Bool) -> Void) {
        // Check if user has enough cash
        if !checkIfUserHasEnoughtMoney() {
            completion(false)
            return
        }
                
        for each in myBalance {
            if each.currency.name == currencySell {
                each.decreaseCurrency(inTheAmountOf: userWantToSell)
            }
            
            if each.currency.name == currencyRecieve {
                each.increaseCurrency(forTheAmount: actualAmountOfCurrency)
            }
        }
        completion(true)
    }
    
    
    // MARK: - API Methods
    
    private func howMuchCurrencyEqualsChecking(amount: Double) {
        serialQueue.sync { [unowned self] in
            self.getActualAmountOfCurrency(amount: amount) {
                let indexPath = IndexPath(item: 1, section: 1)
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    private func getActualAmountOfCurrency(amount: Double, completion: @escaping () -> Void) {
        APIManager.shared().getCurrencyAmount(fromAmount: amount, fromCurrency: currencySell, toCurrency: currencyRecieve) { [weak self] (result: APIManager.Result<ExchangeML>) in
            guard let strongSelf = self else { return }
            
            switch result {
            case let .success(data):
                let amount = Double(data.amount ?? "") ?? 0.0
                strongSelf.actualAmountOfCurrency = amount
                
            case let .failure(error):
                Utils.dismissAlert(title: "Error", message: error, completion: {_,_ in })
                strongSelf.actualAmountOfCurrency = 0.0
            }
            completion()
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
        let dataSource = AppSettings.currencies.compactMap({$0.name.rawValue})
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
                    if each.name.rawValue == item {
                        strongSelf.currencySell = each.name
                    }
                }
            case .recieve:
                for each in AppSettings.currencies {
                    if each.name.rawValue == item {
                        strongSelf.currencyRecieve = each.name
                    }
                }
            }
            
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
    
    override func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BasicVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
    }
    
    // MARK: - IBActions
    
    @IBAction private func submitAction(_ sender: UIButton) {
        sender.bounce()
        currencyConvert() { result in
            if result {
                let feeString = String(format: "%.2f", self.currentFee)
                Utils.dismissAlert(title: "Currency Converted", message: "You have converted \(self.userWantToSell) \(self.currencySell) to \(self.actualAmountOfCurrency) \(self.currencyRecieve). Comision Fee - \(feeString) \(self.currencySell).") { string, result in
                    print("Done")
                    self.loadData()
                }
            } else {
                Utils.dismissAlert(title: "Exchange Error", message: "You don't have enough money.") { _, _ in
                    print("Exchange Error")
                }
            }
        }
    }
}

// MARK: - Extensions

// MARK: - CurrencyExchangeProtocol

extension CurrencyConverterVC: CurrencyExchange {
    func changeCurrencyForSellOrRecieve(type: ExchangeType, sender: UIButton) {
        openCurrencyListDropDown(type: type, sender: sender)
    }
}

// MARK: - UITextFieldDelegate

extension CurrencyConverterVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let components = string.components(separatedBy: UITextField.allowedNumberCharacters)
        let filtered = components.joined(separator: "")
        
        let count = textField.text?.count ?? 0
        // need set max and min amount
        if count > 5 {
            textField.deleteBackward()
        }
        return string == filtered ? true : false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        if text.count < 2 {
            let indexPath = IndexPath(item: 1, section: 1)
            self.actualAmountOfCurrency = 0.0
            self.tableView.reloadRows(at: [indexPath], with: .none)
        } else {
                        
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                self.userWantToSell = Double(textField.text ?? "") ?? 0.0
                self.howMuchCurrencyEqualsChecking(amount: self.userWantToSell)
            }
            
            // simulating a long answer
            /*
            self.startIndicator()
            let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                self.stopIndicator()
                self.userWantToSell = Double(textField.text ?? "") ?? 0.0
                self.howMuchCurrencyEqualsChecking(amount: self.userWantToSell)
            }
           */
        }
    }
}

// MARK: - TableViewDelegate

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
                cell.configureCell(currency: currencySell, delegate: self)
                cell.amountTextField.delegate = self
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyRecieveTVCell.cellIdentifier, for: indexPath) as? CurrencyRecieveTVCell else { return UITableViewCell() }
                cell.configureCell(currency: currencyRecieve, actualAmountOfCurrency: actualAmountOfCurrency, delegate: self)
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
