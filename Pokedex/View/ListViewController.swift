//
//  ViewController.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import UIKit
import Combine
import SnapKit

// UICollectionView Section
enum Section: CaseIterable {
    case pokemonList
}



class ListViewController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = view.frame.width/2 - 8
        layout.itemSize = .init(width: width, height: width + 100)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 8
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
        return view
    }()
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let viewModel: ListViewModel
    
    //MARK: - LifeCycle
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Pokedex"
        layout()
        
        viewModel.setupDataSource(collectionView: self.collectionView)
        viewModel.pokemonListPublisher
            .sink { [weak self] pokemons in
                self?.viewModel.updateCollectionView(with: pokemons)
            }.store(in: &cancellables)
    }
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
