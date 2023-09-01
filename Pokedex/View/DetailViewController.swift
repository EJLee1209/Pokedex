//
//  DetailViewController.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import UIKit
import SDWebImage

final class DetailViewController: UIViewController {
    
    //MARK: - Properties
    private let pokemonImageView = ImageContainerView()
    private let infoView = PokemonInfoView()
    private let statView = PokemonStatView()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [pokemonImageView, infoView, statView])
        sv.axis = .vertical
        sv.spacing = 12
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        return view
    }()
    
    let viewModel: DetailViewModel
    
    //MARK: - LifeCycle
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        bind()
    }
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        pokemonImageView.snp.makeConstraints { make in
            make.height.equalTo(pokemonImageView.snp.width).offset(-50)
        }
        
        pokemonImageView.setImageViewContentInset(inset: 80)
        let gradientLayer = pokemonImageView.setContainerViewGradientLayer(colors: [
            viewModel.firstTypeColor?.cgColor ?? ThemeColor.typeColor(type: .normal).cgColor,
            viewModel.secondTypeColor?.cgColor ?? ThemeColor.typeColor(type: .normal).cgColor])
        
        pokemonImageView.setCornerRadius(gradientLayer: gradientLayer, radius: 12, corners: [.layerMinXMaxYCorner,.layerMaxXMaxYCorner])
    }
    
    private func bind() {
        pokemonImageView.configure(imageUrl: viewModel.imageURL)
        infoView.configure(viewModel: self.viewModel)
        statView.configure(viewModel: self.viewModel)
    }
}





