//
//  PokemonInfoView.swift
//  Pokedex
//
//  Created by 이은재 on 2023/09/01.
//

import UIKit

final class PokemonInfoView: UIView {
    
    //MARK: - Properties
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addShadow(
            offset: CGSize(width: 0, height: 3),
            color: .black,
            shadowRadius: 8.0,
            opacity: 0.3,
            cornerRadius: 12
        )
        return view
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.demiBold(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    private var firstTypeLabel = TypeLabel()
    private var secondTypeLabel = TypeLabel()
    
    private var weightLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var heightLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var typeHStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [firstTypeLabel, secondTypeLabel])
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .fill
        sv.distribution = .fillEqually
        return sv
    }()
    
    private lazy var weightHeightHStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [weightLabel, heightLabel])
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .fill
        return sv
    }()
    
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, typeHStackView, weightHeightHStackView])
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func layout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-50)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
    }
    
    func configure(viewModel: DetailViewModel) {
        nameLabel.text = viewModel.name
        firstTypeLabel.text = viewModel.firstTypeName
        secondTypeLabel.text = viewModel.secondTypeName
        firstTypeLabel.backgroundColor = viewModel.firstTypeColor
        secondTypeLabel.backgroundColor = viewModel.secondTypeColor
        weightLabel.attributedText = viewModel.weightText
        heightLabel.attributedText = viewModel.heightText
        
        if secondTypeLabel.text == nil {
            secondTypeLabel.isHidden = true
        }
        
    }
    
}
