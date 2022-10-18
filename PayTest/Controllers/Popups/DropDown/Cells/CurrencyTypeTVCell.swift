//
//  CurrencyTypeTVCell.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 18.10.2022.
//

import UIKit
import DropDown

class CurrencyTypeTVCell: DropDownCell {
        
    // MARK: - IBOutlets
        
    // @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
