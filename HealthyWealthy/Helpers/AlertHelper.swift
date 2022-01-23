//
//  AlertHelper.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 22.01.22.
//

import Foundation
import SwiftMessages

class AlertHelper {
    
    static func showWarningCardAlertFromTop(_ text: String = "Something went wrong. Please try again!"){
        let view: MessageView
        view = MessageView.viewFromNib(layout: .cardView)
        
        let (config, iconStyle) = setUpConfigAndStyle()
        
        view.configureTheme(.warning, iconStyle: iconStyle)
        view.titleLabel?.isHidden = true
        view.button?.isHidden = true
        
        view.configureContent(title: "", body: text, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Okay", buttonTapHandler: { _ in SwiftMessages.hide() })
        
        // Show
        SwiftMessages.show(config: config, view: view)
    }
    
    static func showSuccessCardAlert(_ text: String, showButton: Bool){
        let view: MessageView
        view = MessageView.viewFromNib(layout: .cardView)
        
        let (config, iconStyle) = setUpConfigAndStyle()
        
        view.configureContent(title: "", body: text, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Okay", buttonTapHandler: { _ in SwiftMessages.hide() })
        
        view.configureTheme(.success, iconStyle: iconStyle)
        view.titleLabel?.isHidden = true
        view.button?.isHidden = !showButton
        
        // Show
        SwiftMessages.show(config: config, view: view)
    }
    
    private static func setUpConfigAndStyle() -> (config: SwiftMessages.Config, iconStyle: IconStyle) {
        let iconStyle: IconStyle
        iconStyle = .light
       
        // Config setup
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.shouldAutorotate = false
        config.interactiveHide = true
        
        return (config, iconStyle)
    }
    
    
}
