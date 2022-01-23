//
//  MerchantsDetailsViewController.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 23.01.22.
//

import UIKit
import MapKit

class MerchantsDetailsViewController: UIViewController {

    var model: MerchantGoCellModel? = nil
    var singleMerchantStatus: MerchantStatus? = nil
    
    @IBOutlet weak var currentEarnedDiscountView: UIView!{
        didSet {
            currentEarnedDiscountView.isHidden = true
        }
    }
    @IBOutlet weak var currentStepCount: UIView!{
        didSet {
            currentStepCount.isHidden = true
        }
    }
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var tariffLbl: UILabel!
    @IBOutlet weak var maxAwardLbl: UILabel!
    @IBOutlet weak var currentStepLbl: UILabel!
    @IBOutlet weak var currentDiscountLbl: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Merchant Details"
        
        nameLbl.text = model?.name
        addressLbl.text = model?.address
        tariffLbl.text = model?.tarif
        maxAwardLbl.text = model?.maxTarif
        currentStepLbl.text = model?.stepCount?.formatted()
        currentDiscountLbl.text = model?.calculatedTarif
        
        currentEarnedDiscountView.isHidden = !(model?.isActive ?? false)
        currentStepCount.isHidden = !(model?.isActive ?? false)
        
        self.navigationController?.hidesBottomBarWhenPushed = true
        if let merchantStatus = MerchantStatus.init(rawValue: model?.status ?? "") {
            switch merchantStatus {
            case .active:
                goBtn.setTitle("Cancel", for: .normal)
            case .completed:
                goBtn.isHidden = true
            }
            singleMerchantStatus = merchantStatus
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let lat = model?.latitude ?? 0
        let long = model?.longitude ?? 0
        
        let locationLatLong = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let mapCoordinates = MKCoordinateRegion(center: locationLatLong, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(mapCoordinates, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation.title = model?.name
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func goBtnAction(_ sender: Any) {
        switch singleMerchantStatus {
        case .active:
            let alert = UIAlertController(title: "Are you sure to cancel?", message: "", preferredStyle: .alert)
           
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
                self?.cancelCurrentMerchant()
            }))
            
            self.present(alert, animated: true, completion: nil)
        default:
            startCurrentMerchant()
        }
    }
    
    private func cancelCurrentMerchant() {
        NetworkManager.shared.cancelMerchant { result in
            switch result {
            case .success(let data):
                AlertHelper.showSuccessCardAlert(data.data, showButton: false)
                self.navigationController?.popViewController(animated: true)
            case .failure:
                AlertHelper.showWarningCardAlertFromTop("Something went wrong. Please try again!")
            }
        }
    }
    
    private func startCurrentMerchant() {
        NetworkManager.shared.startMerchant(merchantId: model?.id ?? "") { result in
            switch result {
            case .success(let data):
                AlertHelper.showSuccessCardAlert(data.data, showButton: true)
                self.navigationController?.popViewController(animated: true)
            case .failure:
                AlertHelper.showWarningCardAlertFromTop("Something went wrong. Please try again!")
            }
        }
    }
}
