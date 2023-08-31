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
    private var pokemonImageView: ImageContainerView = {
        let view = ImageContainerView()
        return view
    }()
    
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
    
    private var firstTypeLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.verticalPadding = 5
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.font = ThemeFont.bold(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private var secondTypeLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.verticalPadding = 5
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
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
    
    //MARK: - Helpers
    private func layout() {
        contentView.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pokemonImageView.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.width)
        }
    }
    
    func configure(pokemon: Pokemon) {
        pokemonImageView.configure(imageUrl: pokemon.imageUrl)
        
        tagLabel.text = "No.\(pokemon.tag)"
        nameLabel.text = pokemon.name
        
        firstTypeLabel.text = pokemon.pokemonTypes.first?.rawValue
        firstTypeLabel.backgroundColor = ThemeColor.typeColor(type: pokemon.pokemonTypes.first!)
        if pokemon.pokemonTypes.count >= 2 {
            secondTypeLabel.text = pokemon.pokemonTypes[1].rawValue
            secondTypeLabel.backgroundColor = ThemeColor.typeColor(type: pokemon.pokemonTypes[1])
        }
    }
}
