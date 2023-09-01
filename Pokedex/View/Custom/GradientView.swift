//
//  GradientView.swift
//  Pokedex
//
//  Created by 이은재 on 2023/09/01.
//

import UIKit

class GradientView: UIView {

    /* Overriding default layer class to use CAGradientLayer */
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    /* Handy accessor to avoid unnecessary casting */
    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    /* Public properties to manipulate colors */
    public var fromColor: UIColor = UIColor.red {
        didSet {
            var currentColors = gradientLayer.colors
            currentColors![0] = fromColor.cgColor
            gradientLayer.colors = currentColors
        }
    }

    public var toColor: UIColor = UIColor.blue {
        didSet {
            var currentColors = gradientLayer.colors
            currentColors![1] = toColor.cgColor
            gradientLayer.colors = currentColors
        }
    }

    /* Initializers overriding to have appropriately configured layer after creation */
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
}
