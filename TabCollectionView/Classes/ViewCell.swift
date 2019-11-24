//
//  ViewCell.swift
//  TabCollectionView
//
//  Created by Akaash Dev on 18/11/19.
//  Copyright © 2019 Akaash Dev. All rights reserved.
//

import UIKit

class ViewCell: UICollectionViewCell {
    
    weak var currentView: UIView?
    weak var currentViewController: UIViewController?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentView?.removeFromSuperview()
    }
    
    func setupCell(with viewController: UIViewController) {
        self.currentViewController = viewController
    }
    
    func displayViewControllerWithAutoLayout(in parentController: UIViewController) {
        
        guard let controller = currentViewController else {
            print("currentViewController is nil. Aborting displayViewController inside ViewCell.")
            return
        }
        
        parentController.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(controller.view)
        controller.view.fillSuperView()
        controller.didMove(toParent: parentController)
        
    }
    
    func displayViewController(in parentController: UIViewController) {
        
        guard let controller = currentViewController else {
            print("currentViewController is nil. Aborting displayViewController inside ViewCell.")
            return
        }
        
        parentController.addChild(controller)
        controller.view.frame = bounds
        addSubview(controller.view)
        controller.didMove(toParent: parentController)
        
    }
    
    func removeViewControllerFromParent() {
        
        guard let controller = currentViewController else {
            print("currentViewController is nil. Aborting removeViewControllerFromParent inside ViewCell.")
            return
        }
        
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        
    }
    
    func setupCell(view: UIView) {
        self.currentView = view
        
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.fillSuperView(safeLayout: false)
        view.layoutIfNeeded()
    }
    
}



class LabelHeaderCell: UICollectionViewCell {
    
//MARK: Properties
    var titleColor: UIColor {
        get {
            return label.textColor
        }
        set {
            label.textColor = newValue
        }
    }
    
//MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.anchorBottom(padding: -8)
        label.alignHorizontallyCenter()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: Life Cycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        label.textColor = .adaptiveTertiaryLabel
    }
    
//MARK: Methods
    func setupHeader(title: String, selected: Bool) {
        label.text = title
        label.textColor = selected ? .adaptiveLabel : .adaptiveTertiaryLabel
    }
    
//MARK: Views and Constraints
    private lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = Font.getMediumFont().semibold
        return view
    }()
    
}
