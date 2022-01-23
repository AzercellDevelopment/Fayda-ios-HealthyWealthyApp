//
//  LoginVC.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 22.01.22.
//

import Foundation
import UIKit

class LoginVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: Any) {
        Routing.shared.presentEmailLoginVC { vc in
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        Routing.shared.presentSignUpVC { vc in
            self.present(vc, animated: true)
        }
    }
}
