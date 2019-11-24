//
//  TabCollectionViewController.swift
//  TabCollectionView
//
//  Created by Akaash Dev on 18/11/19.
//  Copyright © 2019 Akaash Dev. All rights reserved.
//

import UIKit

public extension TabCollectionViewDataSource {
    func tabCollectionView(_ tabCollectionView: TabCollectionView, titleForTabAt index: Int) -> String? {
        return nil
    }
    
    func tabCollectionView(_ tabCollectionView: TabCollectionView, viewControllerAt index: Int) -> UIViewController? {
        return nil
    }
}

open class TabCollectionViewController: UIViewController, TabCollectionViewDataSource, TabCollectionViewDelegate {
    
    open var viewControllers: [UIViewController] = []
    open var titles: [String] = []
    
    private (set) open lazy var tabCollectionView: TabCollectionView = {
        let view = TabCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.datasource = self
        view.delegate = self
        view.parentViewController = self
        return view
    }()
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tabCollectionView)
        tabCollectionView.fillSuperView()
        tabCollectionView.reloadData()
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.tabCollectionView.reloadData()
        })
    }
    
    open var tabHeaderCellType: UICollectionViewCell.Type { return LabelHeaderCell.self }
    
    open var tabContentCellType: UICollectionViewCell.Type { return ViewCell.self }
    
    open func numberOfItems(_ tabCollectionView: TabCollectionView) -> Int {
        return viewControllers.count
    }
    
    open func tabCollectionView(_ tabCollectionView: TabCollectionView, setupHeader header: UICollectionViewCell, at index: Int, selectedTab: Bool) {
        
        if let labelHeader = header as? LabelHeaderCell {
            labelHeader.setupHeader(title: title(at: index), selected: selectedTab)
        }
        
    }
    
    open func tabCollectionView(_ tabCollectionView: TabCollectionView, setupContentCell cell: UICollectionViewCell, at index: Int) {
        
        if let viewCell = cell as? ViewCell,
            let controller = viewController(at: index)
        {
            viewCell.setupCell(with: controller)
        }
        
    }
    
    open func tabCollectionView(_ tabCollectionView: TabCollectionView, viewControllerAt index: Int) -> UIViewController? {
        return viewControllers[safe: index]
    }
    
    open func tabCollectionView(_ tabCollectionView: TabCollectionView, widthForHeaderAt index: Int) -> CGFloat {
        return CGFloat(title(at: index).count * 12 + 30)
    }
    
    open func tabCollectionView(_ tabCollectionView: TabCollectionView, transitioningColor color: UIColor, forHeader header: UICollectionViewCell) {
        if let header = header as? LabelHeaderCell {
            header.titleColor = color
        }
    }
    
    open func title(at index: Int) -> String {
        if let title = tabCollectionView(tabCollectionView, titleForTabAt: index) { return title }
        if let title = viewController(at: index)?.title { return title }
        return "Tab \(index + 1)"
    }
    
    open func viewController(at index: Int) -> UIViewController? {
        return tabCollectionView(tabCollectionView, viewControllerAt: index)
    }
    
}
