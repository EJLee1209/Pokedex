//
//  DetailViewController.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import UIKit
import CombineCocoa
import Combine
import SDWebImage

final class DetailViewController: UIViewController {
    
    //MARK: - Properties
    private let pokemonImageView = ImageContainerView()
    private let infoView = PokemonInfoView()
    private let statView = PokemonStatView()
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .close)
        return button
    }()
    
    private lazy var topHStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [tagLabel, closeButton])
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        return sv
    }()
    
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
        view.alwaysBounceVertical = true
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    private var cancellables: Set<AnyCancellable> = .init()
    let viewModel: DetailViewModel
    
    //MARK: - Status bar hidden properties
    
    var statusBarShouldBeHidden: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    //MARK: - LifeCycle
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatusBar(hidden: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        
        bind()
        setContainerViewGradientLayer()
    }
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(topHStackView)
        topHStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(26)
        }
        
        scrollView.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        pokemonImageView.snp.makeConstraints { make in
            make.height.equalTo(pokemonImageView.snp.width).offset(-50)
        }
        
        pokemonImageView.setImageViewContentInset(inset: 80)
        
    }
    
    private func bind() {
        pokemonImageView.configure(imageUrl: viewModel.imageURL)
        infoView.configure(viewModel: self.viewModel)
        statView.configure(viewModel: self.viewModel)
        tagLabel.text = "#\(viewModel.tag)"
        
        closeButton.tapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }.store(in: &cancellables)
    }
    
    private func setContainerViewGradientLayer() {
        let gradientLayer = pokemonImageView.setContainerViewGradientLayer(colors: [
            viewModel.firstTypeColor?.cgColor ?? ThemeColor.typeColor(type: .normal).cgColor,
            viewModel.secondTypeColor?.cgColor ?? UIColor.white.cgColor])
        
        pokemonImageView.setCornerRadius(gradientLayer: gradientLayer, radius: 12, corners: [.layerMinXMaxYCorner,.layerMaxXMaxYCorner])
    }
    
    private func updateStatusBar(hidden: Bool, completion: ((Bool) -> Void)?) {
        statusBarShouldBeHidden = hidden
        UIView.animate(withDuration: 0.5) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}





