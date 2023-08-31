//
//  ListViewModel.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import Foundation
import Combine
import UIKit

typealias DataSource = UICollectionViewDiffableDataSource<Section, Pokemon>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Pokemon>

final class ListViewModel {
    
    private let pokedexService: PokedexServiceType
    
    private var dataSource: DataSource!
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(pokedexService: PokedexServiceType) {
        self.pokedexService = pokedexService    
    }
    
    var pokemonListPublisher: AnyPublisher<[Pokemon], Never> {
        return pokedexService.pokemonListPublisher
            .eraseToAnyPublisher()
    }
    
    func setupDataSource(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, pokemon in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.identifier, for: indexPath) as! PokemonCell
            cell.configure(pokemon: pokemon)
            return cell
        })
    }
    
    func updateCollectionView(with pokemons: [Pokemon]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(pokemons)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
