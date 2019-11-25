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
    
    override var viewControllers: [UIViewController] {
        didSet {
            deleteTabButton.button.isEnabled = viewControllers.count > 2
            deleteTabButton.alpha = viewControllers.count > 2 ? 1 : 0.7
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = colors.enumerated().map { ColorViewController(color: $0.element, tabIndex: $0.offset) }
        tabCollectionView.headerAlignment = .center
        tabCollectionView.tabHeaderFollowsReadableLayoutGuide = false
        
        view.addSubview(addTabButton)
        view.addSubview(deleteTabButton)
        
        addTabButton.alignHorizontallyCenter()
        addTabButton.safeBottomAnchor(padding: -100)
        
        deleteTabButton.alignHorizontallyCenter()
        deleteTabButton.safeBottomAnchor(padding: -40)
    }
    
    private lazy var addTabButton: AppButton = {
        let view = AppButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.button.setTitle("Add Tab", for: .normal)
        view.button.addTarget(self, action: #selector(handleAddTab), for: .touchUpInside)
        return view
    }()
    
    private lazy var deleteTabButton: AppButton = {
        let view = AppButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.button.setTitle("Delete Tab", for: .normal)
        view.button.setTitleColor(.flatRed, for: .normal)
        view.button.addTarget(self, action: #selector(handleDeleteTab), for: .touchUpInside)
        return view
    }()
    
    @objc private func handleAddTab() {
        let color = colors.randomElement() ?? .flatRed
        let controller = ColorViewController(color: color, tabIndex: viewControllers.count)
        viewControllers.append(controller)
        tabCollectionView.reloadData()
        tabCollectionView.reloadLayout()
    }
    
    @objc private func handleDeleteTab() {
        guard viewControllers.count > 2 else { return }
        viewControllers.removeLast()
        tabCollectionView.reloadData()
        tabCollectionView.reloadLayout()
    }
    
}


class AppButton: UIView {
    
    var labelColor: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
    
    var contentPadding: CGFloat = 16 {
        didSet {
            setInsets(contentPadding)
        }
    }
    
    lazy var blurView: UIVisualEffectView = {
        if #available(iOS 13.0, *) {
            let effect = UIBlurEffect(style: .systemThinMaterial)
            let view = UIVisualEffectView(effect: effect)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        } else {
            let effect = UIBlurEffect(style: .prominent)
            let view = UIVisualEffectView(effect: effect)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
    }()
    
    lazy var button: UIButton = {
        let view = UIButton(type: .system)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.setTitleColor(labelColor, for: .normal)
        view.tintColor = labelColor
        return view
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: button.intrinsicContentSize.width,
                      height: 48)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        alignViews()
    }
    
    func setupView() {
        setInsets(contentPadding)
        layer.masksToBounds = true
    }
    
    func setupSubviews() {
        addSubview(blurView)
        addSubview(button)
    }
    
    func alignViews() {
        blurView.frame = bounds
        button.frame = bounds
        layer.cornerRadius = bounds.height / 2
    }
    
    private func setInsets(_ padding: CGFloat) {
        button.contentEdgeInsets = UIEdgeInsets(top: padding,
                                                left: padding,
                                                bottom: padding,
                                                right: padding)
    }

}

