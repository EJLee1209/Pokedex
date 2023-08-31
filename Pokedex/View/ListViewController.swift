//
//  ViewController.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit

class ListViewController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = view.frame.width/2 - 16
        layout.itemSize = .init(width: width, height: width + 100)
        layout.minimumLineSpacing = 12
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
        bind()
    }
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel.setupDataSource(collectionView: self.collectionView)
        
        viewModel.pokemonListPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pokemons in
                self?.viewModel.updateCollectionView(with: pokemons)
            }.store(in: &cancellables)
        
        collectionView.reachedBottomPublisher()
            .sink { [weak self] _ in
                self?.viewModel.nextPage()
            }.store(in: &cancellables)
    }
    
}
