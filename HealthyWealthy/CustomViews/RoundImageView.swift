//
//  RoundImageView.swift
//  HealthyWealthy
//
//  Created by Aykhan Hajiyev on 23.01.22.
//

import UIKit

final class RoundImageView: UIImageView {
    
    var cornerRadius: CGFloat? {
        didSet {
            updateCornerRadius()
        }
    }
    
    private func updateCornerRadius() {
        layer.cornerRadius = cornerRadius ?? (min(bounds.width, bounds.height) / 2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        updateCornerRadius()
    }
}
