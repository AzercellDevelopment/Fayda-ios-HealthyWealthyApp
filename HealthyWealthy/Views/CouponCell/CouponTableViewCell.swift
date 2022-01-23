//
//  CouponTableViewCell.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 23.01.22.
//

import UIKit

struct CouponTableCellModel {
    let description: String
    let iconUrl: String
    let id: String
    let price: Int
    let subtitle: String
    let title: String
}

class CouponTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var getBtn: UIButton!{
        didSet {
            getBtn.setTitle("Get", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImage.image = nil
    }
    
    func configure(model: CouponTableCellModel) {
        logoImage.load(url: URL(string: model.iconUrl)!)
        nameLbl.text = model.title
        priceLbl.text = model.price.formatted() + " coins"
    }

}
