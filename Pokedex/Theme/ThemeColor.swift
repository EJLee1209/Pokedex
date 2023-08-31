//
//  ThemeColor.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import UIKit

struct ThemeColor {
    static let primary = UIColor(hexString: "D21312")
    
    static let normal = UIColor(hexString: "D8D9DA")
    static let fighting = UIColor(hexString: "F28705")
    static let flying = UIColor(hexString: "95C8FF")
    static let poison = UIColor(hexString: "9652D9")
    static let ground = UIColor(hexString: "AA7939")
    static let rock = UIColor(hexString: "BCB889")
    static let bug = UIColor(hexString: "9FA423")
    static let ghost = UIColor(hexString: "6E4570")
    static let steel = UIColor(hexString: "6AAED3")
    static let fire = UIColor(hexString: "FF612B")
    static let water = UIColor(hexString: "2892FF")
    static let grass = UIColor(hexString: "47BF26")
    static let electric = UIColor(hexString: "F2CB05")
    static let psychic = UIColor(hexString: "FF637F")
    static let ice = UIColor(hexString: "62DFFF")
    static let dragon = UIColor(hexString: "5462D6")
    static let dark = UIColor(hexString: "4F4747")
    static let fairy = UIColor(hexString: "FFB1FF")
    
    static func typeColor(type: PokemonType) -> UIColor {
        switch type {
        case .normal:
            return ThemeColor.normal
        case .fighting:
            return ThemeColor.fighting
        case .flying:
            return ThemeColor.flying
        case .poison:
            return ThemeColor.poison
        case .ground:
            return ThemeColor.ground
        case .rock:
            return ThemeColor.rock
        case .bug:
            return ThemeColor.bug
        case .ghost:
            return ThemeColor.ghost
        case .steel:
            return ThemeColor.steel
        case .fire:
            return ThemeColor.fire
        case .water:
            return ThemeColor.water
        case .grass:
            return ThemeColor.grass
        case .psychic:
            return ThemeColor.psychic
        case .ice:
            return ThemeColor.ice
        case .dragon:
            return ThemeColor.dragon
        case .dark:
            return ThemeColor.dark
        case .fairy:
            return ThemeColor.fairy
        }
    }
}

