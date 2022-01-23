//
//  MerchantGoViewController.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 22.01.22.
//

import UIKit

class MerchantGoViewController: UIViewController {

    var list: [MerchantGoListModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "MerchantViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MerchantViewCell")
        
        let nibHeader = UINib(nibName: "MerchantGoHeaderViewCell", bundle: nil)
        tableView.register(nibHeader, forHeaderFooterViewReuseIdentifier: "MerchantGoHeaderViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postSyncMethod()
        getMerchantsList()
    }
    
    private func getMerchantsList() {
        list = []
        activityIndicator.startAnimating()
        tableView.isUserInteractionEnabled = false
        
        NetworkManager.shared.getMerchants { [weak self] result in
            switch result {
            case .success(let data):
                if !data.data.active.isEmpty {
                    self?.list.append(.init(header: "Your Merchant Go!", cellModels: self?.process(list: data.data.active, isActive: true) ?? []))
                }
                self?.list.append(.init(header: "Select Next Merchant Go!", cellModels: self?.process(list: data.data.nonActive, isActive: false) ?? []))
                
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.tableView.isUserInteractionEnabled = true
                
            case .failure:
                AlertHelper.showWarningCardAlertFromTop("Something went wrong. Please try again!")
                self?.activityIndicator.stopAnimating()
            }
        }
        
    }
    
    private func process(list: [MerchantsListItem], isActive: Bool) -> [MerchantGoCellModel] {
        list.compactMap { listItem in
            MerchantGoCellModel(
                address: listItem.address,
                calculatedTarif: listItem.calculatedTarif,
                id: listItem.id,
                latitude: listItem.latitude,
                longitude: listItem.longitude,
                name: listItem.name,
                startDate: listItem.startDate,
                status: listItem.status,
                stepCount: listItem.stepCount,
                tarif: listItem.tarif,
                iconUrl: listItem.iconUrl,
                isActive: isActive,
                maxTarif: listItem.maxTarif
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

extension MerchantGoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[section].cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantViewCell", for: indexPath) as? MerchantViewCell else {
            return UITableViewCell()
        }
        cell.configure(model: list[indexPath.section].cellModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MerchantGoHeaderViewCell") as? MerchantGoHeaderViewCell else {
            return UITableViewHeaderFooterView()
        }
        
        header.configure(headerTitle: list[section].header)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inputData = list[indexPath.section].cellModels[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        Routing.shared.presentMerchantsDetails(inputData: inputData) { vc in
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
