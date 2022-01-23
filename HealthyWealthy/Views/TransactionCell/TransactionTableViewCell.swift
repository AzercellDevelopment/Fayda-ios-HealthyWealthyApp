//
//  TransactionTableViewCell.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 23.01.22.
//

import UIKit

enum TransactionType: String {
    case merchant = "MERCHANT_COMPLETE"
    case coupon = "COUPON_PURCHASE"
}

struct TransactionCellModel {
    let createDate: Date
    let description: String?
    let iconUrl: String
    let points: String
    let subtitle: String
    let title: String
    let type: TransactionType
}

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImage: RoundImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(model: TransactionCellModel) {
        logoImage.load(url: URL(string: model.iconUrl)!)
        
        switch model.type {
        case .coupon:
            titleLbl.text = model.subtitle
            titleLbl.font = UIFont.boldSystemFont(ofSize: 18)
            subtitleLbl.text = model.title
            priceLbl.text = "-\(model.points) coins"
            subtitleLbl.textColor = UIColor(named: "828282")
        case .merchant:
            titleLbl.text = model.title
            titleLbl.font = UIFont.boldSystemFont(ofSize: 14)
            subtitleLbl.text = model.subtitle
            subtitleLbl.textColor = UIColor(named: "MainGreen")
            priceLbl.text = "\(model.points) steps"
        }
    }
}
