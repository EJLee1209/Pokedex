//
//  AppContentPresentingAnimator.swift
//  Pokedex
//
//  Created by 이은재 on 2023/09/02.
//

import Foundation
import UIKit

fileprivate let transitonDuration: TimeInterval = 1.0


enum AnimationType {
    case present
    case dismiss
}

class PokemonAnimationTransition: NSObject {
    
    let animationType: AnimationType!
    
    init(animationType: AnimationType) {
        self.animationType = animationType
        super.init()
    }
    
}

extension PokemonAnimationTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitonDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if animationType == .present {
            animationForPresent(using: transitionContext)
        } else {
            animationForDismiss(using: transitionContext)
        }
    }
    
    func animationForPresent(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        containerView.alpha = 1.0
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? UINavigationController else { fatalError() }
        
        guard let listVC = fromVC.viewControllers.last as? ListViewController else { fatalError() }
        guard let toVC = transitionContext.viewController(forKey: .to) as? DetailViewController else { fatalError() }
        guard let selectedCell = listVC.selectedCell else { return }
        
        let frame = selectedCell.convert(selectedCell.pokemonImageView.frame, to: fromVC.view)
        toVC.view.frame = frame
        toVC.pokemonImageView.pokemonImageView.frame.size.width = UIScreen.main.bounds.size.width / 2 - 15
        toVC.pokemonImageView.pokemonImageView.frame.size.height = UIScreen.main.bounds.size.width / 2 - 15
        
        containerView.addSubview(toVC.view)
        
        //3.Change original size to final size with animation.
        UIView.animate(withDuration: transitonDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            toVC.view.frame = UIScreen.main.bounds
            toVC.closeButton.alpha = 1
            toVC.tagLabel.alpha = 1
            toVC.pokemonImageView.pokemonImageView.frame.size.width = UIScreen.main.bounds.size.width
            toVC.pokemonImageView.pokemonImageView.frame.size.height = UIScreen.main.bounds.size.width
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
        
        toVC.bind()
    }
    
    func animationForDismiss(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? DetailViewController else { fatalError() }
        guard let toVC = transitionContext.viewController(forKey: .to) as? UINavigationController else { fatalError() }
        guard let listVC = toVC.viewControllers.last as? ListViewController else { fatalError() }
        guard let selectedCell = listVC.selectedCell else { return }
        
        fromVC.view.layer.cornerRadius = 12
        fromVC.view.layer.masksToBounds = true
        
        fromVC.statView.removeFromSuperview()
        fromVC.infoView.removeFromSuperview()
        
        UIView.animate(withDuration: transitonDuration - 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            let frame = selectedCell.convert(selectedCell.pokemonImageView.frame, to: toVC.view)
            fromVC.view.frame = frame
            fromVC.pokemonImageView.pokemonImageView.frame.size.width = UIScreen.main.bounds.size.width / 2 - 15
            fromVC.pokemonImageView.pokemonImageView.frame.size.height = UIScreen.main.bounds.size.width / 2 - 15
            fromVC.closeButton.alpha = 0
            fromVC.tagLabel.alpha = 0
            fromVC.pokemonImageView.setImageViewContentInset(inset: 15)
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
    
}
