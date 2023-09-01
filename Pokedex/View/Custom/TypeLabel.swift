//
//  PaddingLabel.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import UIKit

final class TypeLabel: UILabel {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        verticalPadding = 5
        font = ThemeFont.bold(ofSize: 16)
        clipsToBounds = true
        layer.cornerRadius = 5
        textAlignment = .center
        textColor = .white
    }
}

