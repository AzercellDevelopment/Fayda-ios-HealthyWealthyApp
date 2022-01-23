//
//  Routing.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 22.01.22.
//

import Foundation
import UIKit
import ShiftTransitions

class Routing {
    static let shared = Routing()
    
    private init() { }
    
    private var controllerPresentDuration: TimeInterval = 0.7
    
    func getViewController(id: String, storyboard: String = "Main") -> UIViewController {
        let storyBoard = UIStoryboard.init(name: storyboard, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: id)
    }
    
    func presentLoginVC(complition: @escaping (LoginVC) -> Void) {
        let controller = getViewController(id:String(describing: LoginVC.self), storyboard: "Main") as! LoginVC
        
        controller.shift.defaultAnimation = DefaultAnimations.Scale(.down)
        controller.shift.baselineDuration = controllerPresentDuration
        controller.shift.enable()
        controller.modalPresentationStyle = .fullScreen
        
        complition(controller)
    }
    
    func presentMainTabBarVC(completion: @escaping (MainTabBarController) -> Void) {
        let controller = getViewController(id: String(describing: MainTabBarController.self), storyboard: "Dashboard") as! MainTabBarController
       
        controller.shift.defaultAnimation = DefaultAnimations.Scale(.down)
        controller.shift.baselineDuration = controllerPresentDuration
        controller.shift.enable()
        controller.modalPresentationStyle = .fullScreen
        
        completion(controller)
    }
    
    func presentEmailLoginVC(complition: @escaping (EmailLoginVC) -> Void) {
        let controller = getViewController(id:String(describing: EmailLoginVC.self), storyboard: "Main") as! EmailLoginVC
        
        controller.shift.defaultAnimation = DefaultAnimations.Scale(.down)
        controller.shift.baselineDuration = controllerPresentDuration
        controller.shift.enable()
        controller.modalPresentationStyle = .fullScreen
        
        complition(controller)
    }
    
    func presentSignUpVC(complition: @escaping (SignUpVC) -> Void) {
        let controller = getViewController(id:String(describing: SignUpVC.self), storyboard: "Main") as! SignUpVC
        
        controller.shift.defaultAnimation = DefaultAnimations.Scale(.down)
        controller.shift.baselineDuration = controllerPresentDuration
        controller.shift.enable()
        controller.modalPresentationStyle = .fullScreen
        
        complition(controller)
    }
    
    func presentMerchantsDetails(inputData: MerchantGoCellModel, complition: @escaping (MerchantsDetailsViewController) -> Void) {
        let controller = getViewController(id: String(describing: MerchantsDetailsViewController.self), storyboard: "Dashboard") as! MerchantsDetailsViewController
        
        controller.model = inputData
        controller.shift.defaultAnimation = DefaultAnimations.Scale(.down)
        controller.shift.baselineDuration = controllerPresentDuration
        controller.shift.enable()
        controller.modalPresentationStyle = .fullScreen
        
        complition(controller)
    }
    
    func presentExchangeDetails(inputData: CouponTableCellModel? = nil, transactionModel: TransactionCellModel? = nil, complition: @escaping (ExchangeDetailViewController) -> Void) {
        
        let controller = getViewController(id: String(describing: ExchangeDetailViewController.self), storyboard: "Dashboard") as! ExchangeDetailViewController
        
        controller.model = inputData
        controller.transactionModel = transactionModel
        
        controller.shift.defaultAnimation = DefaultAnimations.Scale(.down)
        controller.shift.baselineDuration = controllerPresentDuration
        controller.shift.enable()
        controller.modalPresentationStyle = .fullScreen
        
        complition(controller)
    }
    
}
