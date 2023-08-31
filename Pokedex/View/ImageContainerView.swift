//
//  ImageContainerView.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import UIKit
import SDWebImage

final class ImageContainerView: UIView {
    
    //MARK: - Properties
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadius(radius: 12)
        view.addShadow(
            offset: CGSize(width: 0, height: 3),
            color: .black,
            radius: 12.0,
            opacity: 0.1
        )
        return view
    }()
    
    private var pokemonImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func layout() {
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.addSubview(pokemonImageView)
        pokemonImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
    }
    
    func configure(imageUrl: String) {
        let url = URL(string: imageUrl)
        pokemonImageView.sd_setImage(with: url)
    }
    
}
