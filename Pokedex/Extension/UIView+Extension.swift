//
//  UIColor+Extension.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import UIKit

extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor, shadowRadius: CGFloat, opacity: Float, cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius

        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = opacity
        
        layer.masksToBounds = false
    }
    
    func addCornerRadius(radius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
    
    func addRoundedCorners(corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [corners]
    }
    
}
