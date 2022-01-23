//
//  LogOutViewController.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 23.01.22.
//

import UIKit

class LogOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alert = UIAlertController(title: "Are you sure to logout?", message: "", preferredStyle: .alert)
       
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { [weak self] _ in
            self?.redirectToDashboard()
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            self?.handleLogout()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func handleLogout() {
        APPDefaults.remove(key: DefaultsKey.token.rawValue)
        APPDefaults.remove(key: DefaultsKey.loginned.rawValue)
        APPDefaults.remove(key: DefaultsKey.lastSyncDate.rawValue)
        Routing.shared.presentLoginVC { vc in
            self.present(vc, animated: true)
        }
    }
    
    private func redirectToDashboard() {
        Routing.shared.presentMainTabBarVC { vc in
            self.present(vc, animated: true)
        }
    }
}
