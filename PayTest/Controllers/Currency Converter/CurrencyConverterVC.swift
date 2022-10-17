//
//  CurrencyConverterVC.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import UIKit

protocol CurrencyExchange: AnyObject {
    func changeCurrency()
}

class CurrencyConverterVC: BasicVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    
    private var currency: [WalletML] = []
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup
        setupTableView()
        //
        loadData()
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
        currency = AppSettings.shared.getBalance()
        print("currency: ", currency)
        tableView.reloadData()
    }
    
    
    // MARK: - IBActions
    
    @IBAction private func submitAction(_ sender: UIButton) {
        sender.bounce()
        tableView.reloadData()
        print("submit")
    }

}

// MARK: - Extensions

// MARK: - CurrencyExchange

extension CurrencyConverterVC: CurrencyExchange {
    func changeCurrency() {
        //
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
            return 2 // options
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
            cell.configureCell(wallet: currency)
            
            return cell
        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencySellTVCell.cellIdentifier, for: indexPath) as? CurrencySellTVCell else { return UITableViewCell() }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyRecieveTVCell.cellIdentifier, for: indexPath) as? CurrencyRecieveTVCell else { return UITableViewCell() }
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
