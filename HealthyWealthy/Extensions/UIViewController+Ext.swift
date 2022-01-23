//
//  UIViewController+Ext.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 23.01.22.
//

import UIKit

extension UIViewController {
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            if let output = filter.outputImage {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
