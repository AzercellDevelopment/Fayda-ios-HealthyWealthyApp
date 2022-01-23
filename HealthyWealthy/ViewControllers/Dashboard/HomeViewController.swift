//
//  ViewController.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 22.01.22.
//

import UIKit
import CoreMotion

class HomeViewController: UIViewController {
    
    let coreMotion = CoreMotionHelper.shared
    lazy var refreshControl = UIRefreshControl()
    
    var transactionList: [TransactionCellModel] = []
    
    @IBOutlet weak var cardContentView: UIView!{
        didSet{
            cardContentView.roundCorners(.allCorners, radius: 16)
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!{
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    @IBOutlet weak var balanceLbl: UILabel!{
        didSet{
            balanceLbl.isHidden = true
        }
    }
    @IBOutlet weak var barcodeImage: UIImageView!
    @IBOutlet weak var refNumberLbbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TransactionTableViewCell")
        
        let nibNotFound = UINib(nibName: "TransactionNotFoundCell", bundle: nil)
        tableView.register(nibNotFound, forCellReuseIdentifier: "TransactionNotFoundCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(getDashboardServices), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDashboardServices()
    }
    
    func getUserStepCount(completion: ((Int)-> Void)? = nil) {
        coreMotion.getUserStepCount { stepCount in
            DispatchQueue.main.async {
                completion?(stepCount)
            }
        }
    }
    
    @objc private func getDashboardServices() {
        self.getUserStepCount { step in
            let parameters = SyncPointsModel(points: step)
            NetworkManager.shared.postUserStepSync(with: parameters) { result in
                switch result {
                case .success(let data):
                    if data == 1 {
                        NetworkManager.shared.getUserBalance { result in
                            switch result {
                            case .success(let data):
                                let response = data.data
                                self.balanceLbl.text = response.balance.formatted()
                                self.balanceLbl.isHidden = false
                                APPDefaults.setString(key: DefaultsKey.lastSyncDate.rawValue, value: response.lastSyncDate)
                                APPDefaults.setString(key: DefaultsKey.userReferenceId.rawValue, value: response.refNum)
                                self.barcodeImage.image = self.generateBarcode(from: response.refNum)
                                self.refNumberLbbl.text = response.refNum
                                self.activityIndicator.stopAnimating()
                            case .failure:
                                AlertHelper.showWarningCardAlertFromTop()
                                self.activityIndicator.stopAnimating()
                            }
                        }
                    }
                case .failure:
                    AlertHelper.showWarningCardAlertFromTop()
                }
            }
        }
        
        // History
        NetworkManager.shared.getUserHistory { [weak self] result in
            switch result {
            case .success(let data):
                self?.transactionList = self?.process(list: data.data) ?? []
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            case .failure:
                AlertHelper.showWarningCardAlertFromTop()
            }
        }
    }
    
    private func process(list: [TransactionHistoryItem]) -> [TransactionCellModel] {
        list.compactMap { model in
            TransactionCellModel(
                createDate: DateTimeHelper().convertStringToDate(dateString: model.createDate) ?? Date(),
                description: model.description,
                iconUrl: model.iconUrl,
                points: model.points,
                subtitle: model.subtitle,
                title: model.title,
                type: (.init(rawValue: model.type) ?? .coupon)
            )
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.count == 0 ? 1 : transactionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if transactionList.isEmpty {
            guard let cellNotFound = tableView.dequeueReusableCell(withIdentifier: "TransactionNotFoundCell", for: indexPath) as? TransactionNotFoundCell else {
                return UITableViewCell()
            }
            return cellNotFound
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as? TransactionTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(model: transactionList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return transactionList.isEmpty ? 180 : 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let inputData = transactionList[indexPath.row]
        switch inputData.type {
        case .coupon:
            Routing.shared.presentExchangeDetails(transactionModel: inputData) { vc in
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .merchant:
            AlertHelper.showWarningCardAlertFromTop("It is a Merchant transaction")
        }
    }
}
