//
//  UIView_Extension.swift
//  BooksApp
//
//  Created by Ayush on 01/05/24.
//

import Foundation
import UIKit

extension UIView {
    func addGradientMask(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = endPoint
        gradientLayer.endPoint = startPoint
        layer.mask = gradientLayer
    }
    
    /// Adds Gradient Overlay
    func addGradientWithAnimation() {
        let gradientLayer = CAGradientLayer()
        
        if self.isKind(of: UIImageView.self) {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = 10
        } else {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = 5
        }
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [#colorLiteral(red: 0.7603881955, green: 0.8053635955, blue: 0.8346464038, alpha: 1).cgColor, #colorLiteral(red: 0.8444721103, green: 0.8841322064, blue: 0.8834492564, alpha: 1).cgColor, #colorLiteral(red: 0.768627451, green: 0.8039215686, blue: 0.831372549, alpha: 1).cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        
        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 1.5
        gradientLayer.add(animation, forKey: animation.keyPath)
        self.layer.addSublayer(gradientLayer)
    }
    
    /// Remove Gradient Overlay
    func removeGradient() {
        if let sublayers = self.layer.sublayers {
            for layers in sublayers {
                if let gradient = layers as? CAGradientLayer {
                    gradient.removeAllAnimations()
                    gradient.removeFromSuperlayer()
                }
            }
        }
    }
}
