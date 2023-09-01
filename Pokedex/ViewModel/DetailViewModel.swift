//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by 이은재 on 2023/09/01.
//

import Foundation
import Combine
import UIKit

final class DetailViewModel {
    
    private let pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    var name: String {
        return pokemon.name
    }
    
    var firstTypeName: String? {
        return pokemon.pokemonTypes.first?.rawValue
    }
    
    var secondTypeName: String? {
        if pokemon.pokemonTypes.count > 1 {
            return pokemon.pokemonTypes[1].rawValue
        }
        return nil
    }
    
    var tag: String {
        return pokemon.tag
    }
    
    var weightText: NSMutableAttributedString {
        return makeMutableAttributedString(firstText: "\(pokemon.height)KG", secondText: "Weight")
    }
    
    var heightText: NSMutableAttributedString {
        return makeMutableAttributedString(firstText: "\(pokemon.height)M", secondText: "Height")
    }
    
    var hp: Int {
        return pokemon.statValue(for: .hp)
    }
    
    var attack: Int {
        return pokemon.statValue(for: .attack)
    }
    
    var defense: Int {
        return pokemon.statValue(for: .defense)
    }
    
    var speed: Int {
        return pokemon.statValue(for: .speed)
    }
    
    
    private func makeMutableAttributedString(firstText: String, secondText: String) -> NSMutableAttributedString {
        
        let attrText = NSMutableAttributedString(
            string: "\(firstText)\n\n",
            attributes: [.font: ThemeFont.bold(ofSize: 16)]
        )
        attrText.append(NSAttributedString(
            string: secondText,
            attributes: [
                .font: ThemeFont.regular(ofSize: 13),
                .foregroundColor: UIColor.lightGray
            ]
        ))
        
        return attrText
    }
    
    
}
