//
//  PokemonCell.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import UIKit
import SDWebImage

final class PokemonCell: UICollectionViewCell {
    
    //MARK: - Properties
    lazy var pokemonImageView = ImageContainerView()
    
    private var tagLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private var firstTypeLabel = TypeLabel()
    private var secondTypeLabel = TypeLabel()
    
    private lazy var typeStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [firstTypeLabel, secondTypeLabel])
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .leading
        sv.distribution = .fillEqually
        return sv
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [pokemonImageView, tagLabel, nameLabel, typeStackView])
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    static let identifier = "PokemonCell"
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        tagLabel.text = ""
        nameLabel.text = ""
        firstTypeLabel.text = ""
        secondTypeLabel.text = ""
        firstTypeLabel.backgroundColor = .clear
        secondTypeLabel.backgroundColor = .clear
        pokemonImageView.configure(imageUrl: "")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //MARK: - Helpers
    private func layout() {
        contentView.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pokemonImageView.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.width)
        }
        
        pokemonImageView.setContainerViewShadow()
        pokemonImageView.setContainerViewCornerRadius(radius: 12)
    }
    
    func configure(pokemon: Pokemon) {
        pokemonImageView.configure(imageUrl: pokemon.imageUrl)
        pokemonImageView.setContainerViewBackgroundColor(
            color: ThemeColor.typeColor(type: pokemon.pokemonTypes.first ?? .normal).withAlphaComponent(0.6))
        
        tagLabel.text = "No.\(pokemon.tag)"
        nameLabel.text = pokemon.name
        
        firstTypeLabel.text = pokemon.pokemonTypes.first?.rawValue
        firstTypeLabel.backgroundColor = ThemeColor.typeColor(type: pokemon.pokemonTypes.first!)
        if pokemon.pokemonTypes.count >= 2 {
            secondTypeLabel.text = pokemon.pokemonTypes[1].rawValue
            secondTypeLabel.backgroundColor = ThemeColor.typeColor(type: pokemon.pokemonTypes[1])
        }
        pokemonImageView.layoutIfNeeded()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        bounceAnimate(isTouched: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bounceAnimate(isTouched: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        bounceAnimate(isTouched: false)
    }
    
    private func bounceAnimate(isTouched: Bool) {
        
        if isTouched {
            PokemonCell.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: [.allowUserInteraction],
                animations: {
                    self.transform = .init(scaleX: 0.96, y: 0.96)
                    self.layoutIfNeeded()
                }, completion: nil)
        } else {
            PokemonCell.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0,
                options: [.allowUserInteraction],
                animations: {
                    self.transform = .identity // 원상태로 복구
                }, completion: nil)
        }
        
    }
}
