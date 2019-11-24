//
//  ViewController.swift
//  TabCollectionView
//
//  Created by Akaash Dev on 11/24/2019.
//  Copyright (c) 2019 Akaash Dev. All rights reserved.
//

import UIKit
import TabCollectionView

class ColorViewController: UIViewController {
    
    lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 44, weight: .heavy)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    convenience init(color: UIColor, tabIndex: Int) {
        self.init()
        title = "Tab #\(tabIndex + 1)"
        view.backgroundColor = color
        view.layer.borderColor = UIColor.purple.cgColor
        view.layer.borderWidth = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = title?.replacingOccurrences(of: " ", with: "\n")
        view.addSubview(label)
        label.alignCenter()
    }
    
}


class ViewController: TabCollectionViewController {
    
    let colors: [UIColor] = [.flatRed, .flatBlue, .flatGray, .flatYellow, .flatOrange, .flatGreen]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = colors.enumerated().map { ColorViewController(color: $0.element, tabIndex: $0.offset) }
        tabCollectionView.headerAlignment = .center
        tabCollectionView.tabHeaderFollowsReadableLayoutGuide = false
    }
    
}
