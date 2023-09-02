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
    var pokemonImageView = ImageContainerView()
    var infoView = PokemonInfoView()
    var statView = PokemonStatView()
    var tagLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.bold(ofSize: 16)
        label.textColor = .white
        label.alpha = 0
        return label
    }()
    
    var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.alpha = 0
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
    
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.alwaysBounceVertical = true
        view.contentInsetAdjustmentBehavior = .never
        view.delegate = self
        return view
    }()
    
    //the point when start to interactive
    var interactiveStartingPoint: CGPoint? = nil

    var draggingDownToDismiss = false
    
    private lazy var dismissPanGesture: UIPanGestureRecognizer = {
        let ges = UIPanGestureRecognizer()
        ges.maximumNumberOfTouches = 1
        ges.addTarget(self, action: #selector(handleDismissPan(gesture:)))
        ges.delegate = self
        return ges
    }()
    
    var gradientLayer: CAGradientLayer?
    
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
        setupTransition()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setContainerViewGradientLayer()
    }
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .white
        view.addGestureRecognizer(dismissPanGesture)
        
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
    
    func bind() {
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
        gradientLayer = pokemonImageView.setContainerViewGradientLayer(colors: [
            viewModel.firstTypeColor?.cgColor ?? ThemeColor.typeColor(type: .normal).cgColor,
            viewModel.secondTypeColor?.cgColor ?? UIColor.white.cgColor])
        
        pokemonImageView.setCornerRadius(gradientLayer: gradientLayer!, radius: 12, corners: [.layerMinXMaxYCorner,.layerMaxXMaxYCorner])
    }
    
    func changeGradientLayer(colors: [CGColor]) {
        gradientLayer?.colors = colors
    }
    
    private func updateStatusBar(hidden: Bool, completion: ((Bool) -> Void)?) {
        statusBarShouldBeHidden = hidden
        UIView.animate(withDuration: 0.5) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private func setupTransition() {
        modalPresentationStyle = .custom
        transitioningDelegate = self
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    @objc private func handleDismissPan(gesture: UIPanGestureRecognizer) {
        if !draggingDownToDismiss {
            return
        }
        
        let startingPoint: CGPoint
        
        if let p = interactiveStartingPoint {
            startingPoint = p
        } else {
            startingPoint = gesture.location(in: nil)
            interactiveStartingPoint = startingPoint
        }

        let currentLocation = gesture.location(in: nil)
        
        var progress = (currentLocation.y - startingPoint.y) / 100
        
        //prevent viewController bigger when scrolling up
        if currentLocation.y <= startingPoint.y {
            progress = 0
        }
        
        if progress >= 1.0 {
            dismiss(animated: true, completion: nil)
            stopDismissPanGesture(gesture)
            return
        }

        let targetShrinkScale: CGFloat = 0.86
        let currentScale: CGFloat = 1 - (1 - targetShrinkScale) * progress
        
        switch gesture.state {
        case .began,.changed:
            scrollView.isScrollEnabled = false
            gesture.view?.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
            gesture.view?.layer.cornerRadius = 15.0 * (progress)
            scrollView.showsVerticalScrollIndicator = false
        case .cancelled,.ended:
            scrollView.isScrollEnabled = true
            stopDismissPanGesture(gesture)
        default:
            break
        }
    }
    
    private func stopDismissPanGesture(_ gesture: UIPanGestureRecognizer) {
        draggingDownToDismiss = false
        interactiveStartingPoint = nil
        scrollView.showsVerticalScrollIndicator = true
        
        UIView.animate(withDuration: 0.2) {
            gesture.view?.transform = CGAffineTransform.identity
        }
    } 
    
}

//MARK: - UIViewControllerTransitioningDelegate
extension DetailViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PokemonAnimationTransition(animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PokemonAnimationTransition(animationType: .dismiss)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = .zero
            draggingDownToDismiss = true
        }
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
