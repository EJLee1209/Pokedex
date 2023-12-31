//
//  LoadingView.swift
//  Pokedex
//
//  Created by 이은재 on 2023/09/01.
//

import UIKit

final class LoadingView: UIView {
    
    //MARK: - Properties
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.5
        return view
    }()
    
    private let oneDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.clipsToBounds = true
        return view
    }()
    
    private let twoDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.clipsToBounds = true
        return view
    }()
    
    private let threeDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [oneDotView,twoDotView,threeDotView])
        sv.axis = .horizontal
        sv.spacing = 8
        return sv
    }()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func layout() {
        isHidden = true
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        [oneDotView, twoDotView, threeDotView].forEach { view in
            view.snp.makeConstraints { make in
                make.size.equalTo(12)
            }
            
            view.addCornerRadius(radius: 6)
        }
    }
    
    func setLoadingViewCornerRadius() {
        backgroundView.addCornerRadius(radius: backgroundView.frame.height/2)
    }
    
    func showLoadingViewAndStartAnimation() {
        isHidden = false
        
        let opacityKeyframe = makeOpacityKeyFrame()
        oneDotView.layer.add(opacityKeyframe, forKey: "oneDotAnim")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
            self?.twoDotView.layer.add(opacityKeyframe, forKey: "twoDotAnim")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
            self?.threeDotView.layer.add(opacityKeyframe, forKey: "threeDotAnim")
        }
    }
    
    func hideLoadingViewAndStopAnimation() {
        self.isHidden = true
        
        [oneDotView, twoDotView, threeDotView].forEach { $0.layer.removeAllAnimations() }
    }
    
    private func makeOpacityKeyFrame() -> CAKeyframeAnimation {
        let opacityKeyframe = CAKeyframeAnimation(keyPath: "opacity")
        opacityKeyframe.values = [0.3, 1.0, 0.3]
        opacityKeyframe.keyTimes = [0, 0.5, 1]
        opacityKeyframe.duration = 1.5
        opacityKeyframe.repeatCount = .infinity
        return opacityKeyframe
    }
}
