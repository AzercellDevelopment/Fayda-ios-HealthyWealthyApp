//
//  EmailLoginVC.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 22.01.22.
//

import UIKit
import SkyFloatingLabelTextField

class EmailLoginVC: UIViewController {

    @IBOutlet weak var emailTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTxtField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        if let email = emailTxtField.text, let password = passwordTxtField.text {
            if email.isEmpty || password.isEmpty {
                AlertHelper.showWarningCardAlertFromTop("Username or password are incorrect!")
            } else {
                let loginParam = LoginParams(email: email, password: password)
                NetworkManager.shared.login(with: loginParam) { result in
                    switch result {
                    case .success(let data):
                        APPDefaults.setString(key: DefaultsKey.token.rawValue, value: data.data.token)
                        APPDefaults.setBool(key: DefaultsKey.loginned.rawValue, value: true)
                        Routing.shared.presentMainTabBarVC { vc in
                            self.present(vc, animated: true)
                        }
                    case .failure:
                        AlertHelper.showWarningCardAlertFromTop("Wrong user.")
                    }
                }
            }
        }
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        Routing.shared.presentSignUpVC { vc in
            self.present(vc, animated: true)
        }
    }
}
