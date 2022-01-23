//
//  ExchangeViewController.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 22.01.22.
//

import UIKit

class ExchangeViewController: UIViewController {

    var couponList: [CouponTableCellModel] = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!{
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CouponTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CouponTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postSyncMethod()
        activityIndicator.startAnimating()
        NetworkManager.shared.getCouponsList { [weak self] result in
            switch result {
            case .success(let data):
                self?.couponList = self?.process(list: data.data) ?? []
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            case .failure:
                AlertHelper.showWarningCardAlertFromTop("Something went wrong. Please try again!")
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func process(list: [CouponsData]) -> [CouponTableCellModel] {
        list.compactMap { model in
            CouponTableCellModel(
                description: model.description,
                iconUrl: model.iconUrl,
                id: model.id,
                price: model.price,
                subtitle: model.subtitle,
                title: model.title
            )
        }
    }
    
    private func postSyncMethod() {
        CoreMotionHelper.shared.getUserStepCount { step in
            let parametrs = SyncPointsModel(points: step)
            NetworkManager.shared.postUserStepSync(with: parametrs) { result in
                switch result {
                case .success:
                    break
                case .failure:
                    AlertHelper.showWarningCardAlertFromTop("Something went wrong. Please try again!")
                }
            }
        }
    }
}


extension ExchangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CouponTableViewCell", for: indexPath) as? CouponTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(model: couponList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let inputData = couponList[indexPath.row]
        Routing.shared.presentExchangeDetails(inputData: inputData) { vc in
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

