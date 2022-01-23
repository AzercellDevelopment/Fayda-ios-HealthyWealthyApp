//
//  MerchantViewCell.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 22.01.22.
//

import UIKit

struct MerchantGoCellModel {
    let address: String?
    let calculatedTarif: String?
    let id: String?
    let latitude: Double
    let longitude: Double
    let name: String
    let startDate: String?
    let status: String?
    let stepCount: Int?
    let tarif: String
    let iconUrl: String
    let isActive: Bool
    let maxTarif: String
}

class MerchantViewCell: UITableViewCell {

    @IBOutlet weak var merchantImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!{
        didSet {
            statusLbl.isHidden = true
            statusLbl.text = nil
        }
    }
    
    @IBOutlet weak var getBtn: UIButton!{
        didSet {
            getBtn.roundCorners(.allCorners, radius: 16)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.roundCorners(.allCorners, radius: 16)
        contentView.backgroundColor = .white
        backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        merchantImageView.image = nil
        titleLbl.text = nil
        statusLbl.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    func configure(model: MerchantGoCellModel) {
        titleLbl.text = model.name
        if let status = model.status {
            statusLbl.isHidden = false
            statusLbl.text = "Status: \(status)"
        }
        let buttonTitle = model.isActive ? "Review" : "Go!"
        getBtn.setTitle(buttonTitle, for: .normal)
        getBtn.sizeToFit()
        merchantImageView.load(url: URL(string: model.iconUrl)!)
    }
}
