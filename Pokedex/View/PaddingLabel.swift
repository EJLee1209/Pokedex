//
//  PaddingLabel.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import UIKit

final class PaddingLabel: UILabel {
    
    var verticalPadding: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    var horizontalPadding: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let baseSize = super.intrinsicContentSize
        return CGSize(width: baseSize.width + horizontalPadding, height: baseSize.height + verticalPadding)
    }
}

