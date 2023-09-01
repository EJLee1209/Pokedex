//
//  StatGraph.swift
//  Pokedex
//
//  Created by 이은재 on 2023/09/01.
//

import UIKit

final class statGraph: UIView {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeFont.regular(ofSize: 14)
        label.textColor = .darkGray
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.textAlignment = .center
        return label
    }()
    
    private let graphBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.addCornerRadius(radius: 15)
        return view
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, graphBackground])
        sv.axis = .horizontal
        sv.spacing = 12
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    private let graphView: UIView = {
        let view = UIView()
        view.addCornerRadius(radius: 15)
        return view
    }()
    
    private let statLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = ThemeFont.regular(ofSize: 12)
        label.layer.opacity = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        
        graphBackground.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        graphBackground.addSubview(graphView)
        graphView.snp.makeConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.width.equalTo(0)
        }
        
        graphView.addSubview(statLabel)
        statLabel.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
        }
    }
    
    func configure(
        statName: String,
        statValue: Int,
        statColor: UIColor
    ) {
        nameLabel.text = statName
        statLabel.text = "\(statValue)/300"
        graphView.backgroundColor = statColor
        
        let graphWidth = graphBackground.frame.width / 300.0 * CGFloat(statValue)
        
        if graphWidth <= 50 {
            statLabel.snp.remakeConstraints { make in
                make.left.equalTo(graphView.snp.right)
                make.top.bottom.equalToSuperview()
            }
            statLabel.textColor = .black
        }
        
        graphView.snp.updateConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.width.equalTo(graphWidth)
        }
        
        UIView.animate(withDuration: 1) {
            self.statLabel.layer.opacity = 1
            self.layoutIfNeeded()
        }
    }
}
