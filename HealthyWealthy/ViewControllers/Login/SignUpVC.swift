//
//  SignUpVC.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 22.01.22.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpVC: UIViewController {

    @IBOutlet weak var emailTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordTxtField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        if let email = emailTxtField.text, let password = passwordTxtField.text, let confirmPassword = confirmPasswordTxtField.text {
            if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                AlertHelper.showWarningCardAlertFromTop("Fields must be filled")
            } else if password != confirmPassword {
                AlertHelper.showWarningCardAlertFromTop("Passwords are not matched")
            } else {
                let registerParam = LoginParams(email: email, password: password)
                
                NetworkManager.shared.register(with: registerParam) { result in
                    switch result {
                    case .success(let data):
                        APPDefaults.setString(key: DefaultsKey.token.rawValue, value:data.data.token)
                        APPDefaults.setBool(key: DefaultsKey.loginned.rawValue, value: true)
                        Routing.shared.presentMainTabBarVC { vc in
                            self.present(vc, animated: true)
                        }
                    case .failure(_):
                        AlertHelper.showWarningCardAlertFromTop("Something went wrong.")
                    }
                }
            }
        }
    }
}
