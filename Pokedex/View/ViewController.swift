//
//  ViewController.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
    }
}
