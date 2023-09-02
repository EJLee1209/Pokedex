//
//  AppContentPresentation.swift
//  Pokedex
//
//  Created by 이은재 on 2023/09/02.
//

import UIKit

class CardPresentationController: UIPresentationController {
    
    lazy var blurView: UIVisualEffectView = {
        var view = UIVisualEffectView(effect: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = containerView else  { fatalError() }
        
        containerView.insertSubview(blurView, at: 0)
        
        blurView.alpha = 0.0
        blurView.frame = containerView.frame
        
        containerView.layoutIfNeeded()
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            blurView.alpha = 1.0
            blurView.effect = UIBlurEffect(style: .light)
            return
        }
        coordinator.animate(alongsideTransition: { (animation) in
            self.blurView.alpha = 1.0
            self.blurView.effect = UIBlurEffect(style: .light)
            containerView.layoutIfNeeded()
        }, completion: nil)
        
    }
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        guard let coordinator = presentingViewController.transitionCoordinator else {
            blurView.alpha = 0.0
            return
        }
        coordinator.animate(alongsideTransition: { (animator) in
            self.blurView.alpha = 0.0
            self.containerView?.layoutIfNeeded()
        }, completion: nil)
    }
}
