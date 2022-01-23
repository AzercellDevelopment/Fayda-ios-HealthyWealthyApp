//
//  MerchantGoHeaderViewCell.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 22.01.22.
//

import UIKit

class MerchantGoHeaderViewCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var headerLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(headerTitle: String) {
        headerLbl.text = headerTitle
    }
    
}
