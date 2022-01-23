//
//  ExchangeDetailViewController.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 23.01.22.
//

import UIKit

class ExchangeDetailViewController: UIViewController {

    var model: CouponTableCellModel? = nil
    var transactionModel: TransactionCellModel? = nil
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var couponImage: UIImageView!
    
    @IBOutlet weak var priceContent: UIView! {
        didSet {
            priceContent.roundCorners(.allCorners, radius: 8)
        }
    }
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var desctiptionLbl: UILabel!
    
    @IBOutlet weak var exchangeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = model {
            nameLbl.text = model.title
            couponImage.load(url: URL(string: model.iconUrl)!)
            priceLbl.text = model.price.formatted() + " coins"
            desctiptionLbl.text = model.description
            exchangeBtn.isHidden = false
        }
        if let transactionModel = transactionModel {
            nameLbl.text = transactionModel.title
            couponImage.load(url: URL(string: transactionModel.iconUrl)!)
            priceLbl.text = transactionModel.subtitle
            desctiptionLbl.text = transactionModel.description
            exchangeBtn.isHidden = true
        }
    }
    
    @IBAction func purchaseCoupon(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure to exchange?", message: "", preferredStyle: .alert)
       
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            self?.buyCouponWith(couponId: self?.model?.id ?? "")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func buyCouponWith(couponId: String) {
        NetworkManager.shared.buyCoupon(couponId: couponId) { result in
            switch result {
            case .success(let data):
                AlertHelper.showSuccessCardAlert(data.data, showButton: true)
                Routing.shared.presentMainTabBarVC { vc in
                    self.present(vc, animated: true)
                }
            case .failure:
                AlertHelper.showWarningCardAlertFromTop("Something went wrong. Please try again!")
            }
        }
    }
}
