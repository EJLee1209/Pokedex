//
//  ContentTransitionController.swift
//  Pokedex
//
//  Created by 이은재 on 2023/09/02.
//

import Foundation
import UIKit


class ContentTransitionController: NSObject {
    
    var superVC: UIViewController?
    var indexPath: IndexPath?
    
    
    
}

extension ContentTransitionController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
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
