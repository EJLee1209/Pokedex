//
//  PokemonStatView.swift
//  Pokedex
//
//  Created by 이은재 on 2023/09/01.
//

import UIKit

final class PokemonStatView: UIView {
    
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Base Stats"
        label.font = ThemeFont.bold(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let hpStatView: statGraph = statGraph()
    private let atkStatView: statGraph = statGraph()
    private let defStatView: statGraph = statGraph()
    private let spdStatView: statGraph = statGraph()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel,hpStatView,atkStatView,defStatView,spdStatView])
        sv.axis = .vertical
        sv.spacing = 12
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
            make.edges.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func configure(viewModel: DetailViewModel) {
        hpStatView.configure(statName: "HP", statValue: viewModel.hp, statColor: .systemRed)
        atkStatView.configure(statName: "ATK", statValue: viewModel.attack, statColor: .systemYellow)
        defStatView.configure(statName: "DEF", statValue: viewModel.defense, statColor: .systemBlue)
        spdStatView.configure(statName: "SPD", statValue: viewModel.speed, statColor: .systemGray)
    }
    
}


