//
//  ViewCell.swift
//  TabCollectionView
//
//  Created by Akaash Dev on 18/11/19.
//  Copyright © 2019 Akaash Dev. All rights reserved.
//

import UIKit

open class ViewCell: UICollectionViewCell {
    
    open weak var currentView: UIView?
    open weak var currentViewController: UIViewController?
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        currentView?.removeFromSuperview()
    }
    
    open func setupCell(with viewController: UIViewController) {
        self.currentViewController = viewController
    }
    
    open func displayViewControllerWithAutoLayout(in parentController: UIViewController) {
        
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
    
    open func displayViewController(in parentController: UIViewController) {
        
        guard let controller = currentViewController else {
            print("currentViewController is nil. Aborting displayViewController inside ViewCell.")
            return
        }
        
        parentController.addChild(controller)
        controller.view.frame = bounds
        addSubview(controller.view)
        controller.didMove(toParent: parentController)
        
    }
    
    open func removeViewControllerFromParent() {
        
        guard let controller = currentViewController else {
            print("currentViewController is nil. Aborting removeViewControllerFromParent inside ViewCell.")
            return
        }
        
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        
    }
    
    open func setupCell(view: UIView) {
        self.currentView = view
        
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.fillSuperView(safeLayout: false)
        view.layoutIfNeeded()
    }
    
}



open class LabelHeaderCell: UICollectionViewCell {
    
    //MARK: Properties
    private (set) public var normalHeaderColor: UIColor = .adaptiveTertiaryLabel
    private (set) public var selectedHeaderColor: UIColor = .adaptiveLabel
    
    //MARK: Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.anchorBottom(padding: -8)
        label.alignHorizontallyCenter()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life Cycle Methods
    open override func prepareForReuse() {
        super.prepareForReuse()
        label.textColor = .adaptiveTertiaryLabel
    }
    
    //MARK: Methods
    open func setupHeader(title: String, selected: Bool) {
        label.text = title
        label.textColor = selected ? .adaptiveLabel : .adaptiveTertiaryLabel
    }
    
    open func setTransitioningDelta(_ delta: CGFloat) {
        label.textColor = getTransitioningColor(delta: delta)
    }
    
    //MARK: Private Methods
    private func getTransitioningColor(delta: CGFloat) -> UIColor {
        return Utils.getTransitioningColor(
            from: selectedHeaderColor,
            to: normalHeaderColor,
            delta: delta
        )
    }
    
    //MARK: Views and Constraints
    private lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = Font.getMediumFont().semibold
        return view
    }()
    
}
