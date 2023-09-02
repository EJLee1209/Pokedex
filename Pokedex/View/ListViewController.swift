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
        let layout = createFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
        view.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        view.delaysContentTouches = false
        return view
    }()
    
    private let loadingView: LoadingView = .init(frame: .zero)
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let viewModel: ListViewModel
    var transition: ContentTransitionController = .init()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        
        loadingView.setLoadingViewCornerRadius()
    }
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    private func bind() {
        viewModel.setupDataSource(collectionView: self.collectionView)
        
        viewModel.pokemonListPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pokemons in
                if pokemons.count % 20 == 0 {
                    self?.viewModel.updateCollectionView(with: pokemons)
                    self?.loadingView.hideLoadingViewAndStopAnimation()
                }
                
            }.store(in: &cancellables)
        
        collectionView.reachedBottomPublisher()
            .sink { [weak self] _ in
                self?.loadingView.showLoadingViewAndStartAnimation()
                self?.viewModel.nextPage()
            }.store(in: &cancellables)
        
        collectionView.didSelectItemPublisher
            .sink { [weak self] indexPath in
                self?.didSelectItem(at: indexPath)
            }.store(in: &cancellables)
    }
    
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = view.frame.width/2 - 15
        layout.itemSize = .init(width: width, height: width + 100)
        return layout
    }
    
    private func didSelectItem(at indexPath: IndexPath) {
        let pokemon = viewModel.pokemonList[indexPath.row]
        let detailVM = DetailViewModel(pokemon: pokemon)
        let detailVC = DetailViewController(viewModel: detailVM)
        
        // transition에 데이터를 넘겨줌
        transition.indexPath = indexPath
        transition.superVC = detailVC
        
        detailVC.modalPresentationStyle = .custom
        detailVC.transitioningDelegate = transition
        detailVC.modalPresentationCapturesStatusBarAppearance = true
        
        present(detailVC, animated: true)
    }
    
}
