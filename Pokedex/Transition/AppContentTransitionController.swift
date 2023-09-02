//
//  ContentTransitionController.swift
//  Pokedex
//
//  Created by 이은재 on 2023/09/02.
//

import Foundation
import UIKit


class AppContentTransitionController: NSObject {
    
    var superVC: UIViewController?
    var indexPath: IndexPath?
    var viewModel: DetailViewModel?
    
}

extension AppContentTransitionController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AppcontentPresentaion(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
