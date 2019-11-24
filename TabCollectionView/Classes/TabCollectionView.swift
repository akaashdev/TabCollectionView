//
//  TabCollectionView.swift
//  TabCollectionView
//
//  Created by Akaash Dev on 18/11/19.
//  Copyright © 2019 Akaash Dev. All rights reserved.
//

import UIKit

struct TabCollectionViewConstant {
    static let tabIndicatorHeight: CGFloat = 2
    static let tabIndicatorPadding: CGFloat = 8
}

public protocol ClassProtocol: class { }

public protocol TabCollectionViewDataSource: ClassProtocol {
    var tabHeaderCellType: UICollectionViewCell.Type { get }
    var tabContentCellType: UICollectionViewCell.Type { get }
    func numberOfItems(_ tabCollectionView: TabCollectionView) -> Int
    func tabCollectionView(_ tabCollectionView: TabCollectionView, setupHeader header: UICollectionViewCell, at index: Int, selectedTab: Bool)
    func tabCollectionView(_ tabCollectionView: TabCollectionView, setupContentCell cell: UICollectionViewCell, at index: Int)
    func tabCollectionView(_ tabCollectionView: TabCollectionView, titleForTabAt index: Int) -> String?
    func tabCollectionView(_ tabCollectionView: TabCollectionView, viewControllerAt index: Int) -> UIViewController?
}

public protocol TabCollectionViewDelegate: ClassProtocol {
    func tabCollectionView(_ tabCollectionView: TabCollectionView, widthForHeaderAt index: Int) -> CGFloat
    func tabCollectionView(_ tabCollectionView: TabCollectionView, willDisplay contentCell: UICollectionViewCell, inContent collectionView: UICollectionView, forItemAt index: Int)
    func tabCollectionView(_ tabCollectionView: TabCollectionView, didEndDisplaying contentCell: UICollectionViewCell, inContent collectionView: UICollectionView, forItemAt index: Int)
    func tabCollectionView(_ tabCollectionView: TabCollectionView, transitioningColor color: UIColor, forHeader header: UICollectionViewCell)
}

public extension TabCollectionViewDelegate {
    func tabCollectionView(_ tabCollectionView: TabCollectionView, widthForHeaderAt index: Int) -> CGFloat {
        return tabCollectionView.tabHeaderCellWidth
    }
    
    func tabCollectionView(_ tabCollectionView: TabCollectionView, willDisplay contentCell: UICollectionViewCell, inContent collectionView: UICollectionView, forItemAt index: Int)
    {  }
    
    func tabCollectionView(_ tabCollectionView: TabCollectionView, didEndDisplaying contentCell: UICollectionViewCell, inContent collectionView: UICollectionView, forItemAt index: Int)
    {  }
    
    func tabCollectionView(_ tabCollectionView: TabCollectionView, transitioningColor color: UIColor, forHeader header:
        UICollectionViewCell)
    {  }
}

public class TabCollectionView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //MARK: Properties
    public weak var parentViewController: UIViewController?
    public weak var datasource: TabCollectionViewDataSource? {
        didSet {
            registerCellTypes()
        }
    }
    
    public weak var delegate: TabCollectionViewDelegate? {
        didSet {
            reloadTabIndicatorView()
        }
    }
    
    public var tabHeaderCellWidth: CGFloat = 100 {
        didSet {
            reloadTabIndicatorView()
        }
    }
    
    public var tabHeaderHeight: CGFloat = 44 {
        didSet {
            reloadLayout()
        }
    }
    
    public var isTabHeaderHidden: Bool = false {
        didSet {
            reloadLayout()
        }
    }
    
    public enum HeaderAlignment {
        case leading, trailing, center, left, right
    }
    
    public var tabHeaderFollowsReadableLayoutGuide: Bool = true
    public var headerAlignment: HeaderAlignment = .leading
    
    public var normalHeaderColor: UIColor = .adaptiveTertiaryLabel
    public var selectedHeaderColor: UIColor = .adaptiveLabel
    
//MARK: Get-Only Properties
    public var headerCollectionView: UICollectionView {
        return tabHeaderCollectionView_
    }
    
    public var contentCollectionView: UICollectionView {
        return contentCollectionView_
    }
    
    public var bounces: Bool {
        get { return contentCollectionView.bounces }
        set { contentCollectionView.bounces = newValue }
    }
    
    public var numberOfItems: Int {
        return datasource?.numberOfItems(self) ?? 0
    }
    
    private (set) public var currentSelectedTab: Int = 0
    
    //MARK: Private Properties
    private let kTabHeaderCollectionViewTag = 1
    private let kContentCollectionViewTag = 2
    
    private let kTabIndicatorHeight: CGFloat = TabCollectionViewConstant.tabIndicatorHeight
    private let kTabIndicatorPadding: CGFloat = TabCollectionViewConstant.tabIndicatorPadding
    
    private let kTabHeaderCellId = "tabHeaderCell"
    private let kContentCellId = "contentCell"
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutMargins = .zero
        backgroundColor = .adaptiveBackground
        clipsToBounds = true
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        reloadTabIndicatorView()
        updateHeaderViewWidthConstraint()
        refreshScrollOffset()
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        headerAlignmentActiveConstraints.forEach { $0.deactivate() }
        headerAlignmentActiveConstraints = getHeaderViewAlignmentConstraints()
        headerAlignmentActiveConstraints.forEach { $0.activate() }
    }
    
    //MARK: Methods
    public func reloadData() {
        tabHeaderCollectionView_.reloadData()
        contentCollectionView_.reloadData()
    }
    
    public func reloadLayout() {
        updateTabHeaderLayout()
        reloadTabIndicatorView()
        setNeedsUpdateConstraints()
        layoutIfNeeded()
    }
    
    public func scrollToTab(at index: Int, animated: Bool) {
        currentSelectedTab = index
        interactiveScroll = false
        contentCollectionView_.scrollToItem(at: indexPath(for: index), at: .centeredHorizontally, animated: animated)
        runOnMainThread(after: 0.2) { [weak self] in
            self?.tabHeaderCollectionView_.reloadData()
        }
    }
    
    public func headerWidth(at index: Int) -> CGFloat {
        return delegate?.tabCollectionView(self, widthForHeaderAt: index) ?? tabHeaderCellWidth
    }
    
    
    //MARK: Collectionview Datasurce
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case kTabHeaderCollectionViewTag:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kTabHeaderCellId, for: indexPath)
            datasource?.tabCollectionView(self, setupHeader: cell, at: indexPath.item, selectedTab: indexPath.item == currentSelectedTab)
            return cell
            
        case kContentCollectionViewTag:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellId, for: indexPath)
            datasource?.tabCollectionView(self, setupContentCell: cell, at: indexPath.item)
            return cell
            
        default: return UICollectionViewCell()
        }
        
    }
    
    //MARK: Collectionview Delegates
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == kTabHeaderCollectionViewTag {
            scrollToTab(at: indexPath.item, animated: true)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        
        case kTabHeaderCollectionViewTag:
            if let headerWidth = delegate?.tabCollectionView(self, widthForHeaderAt: indexPath.item) {
                return CGSize(width: headerWidth, height: tabHeaderHeight)
            }
            return CGSize(width: tabHeaderCellWidth, height: tabHeaderHeight)
        
        case kContentCollectionViewTag:
            return CGSize(width: bounds.width, height: bounds.height - tabHeaderHeight - kTabIndicatorHeight)
        
        default: return .zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == kContentCollectionViewTag {
            delegate?.tabCollectionView(self, willDisplay: cell, inContent: contentCollectionView_, forItemAt: indexPath.item)
            
            if let parentController = parentViewController, let viewCell = cell as? ViewCell {
                viewCell.displayViewController(in: parentController)
            }
            
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == kContentCollectionViewTag {
            
            delegate?.tabCollectionView(self, didEndDisplaying: cell, inContent: contentCollectionView_, forItemAt: indexPath.item)
            
            if let _ = parentViewController, let viewCell = cell as? ViewCell {
                viewCell.removeViewControllerFromParent()
            }
            
        }
    }
    
    //MARK: Scrollview Delegates
    private var interactiveScroll: Bool = false
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.tag == kContentCollectionViewTag {
            interactiveScroll = true
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.tag == kContentCollectionViewTag else { return }
        
        guard let delegate = delegate else {
            let delta = scrollView.contentOffset.x / bounds.width
            tabIndicatorView.frame.origin.x = (delta * tabHeaderCellWidth) + kTabIndicatorPadding
            return
        }
        
        let numberOfTabs = numberOfItems
        
        let ratio = scrollView.contentOffset.x / bounds.width
        let leftTab = Int(ratio)
        let rightTab = leftTab + 1
        
        let translationRatio = ratio - CGFloat(leftTab)
        
        let leftTabWidth = headerWidth(at: leftTab)
        let rightTabWidth = headerWidth(at: rightTab)
        let calculatedWidth = leftTabWidth + (translationRatio * (rightTabWidth - leftTabWidth))
        
        if let cellFrame = tabHeaderCollectionView_.layoutAttributesForItem(at: indexPath(for: leftTab))?.frame {
            tabIndicatorView.frame.origin.x = cellFrame.minX + (translationRatio * leftTabWidth) + kTabIndicatorPadding
            tabIndicatorView.frame.size = CGSize(width: calculatedWidth - (2 * kTabIndicatorPadding), height: kTabIndicatorHeight)
        }
        
        let finalContentOffsetX = (ratio/CGFloat(numberOfTabs - 1)) * (tabHeaderCollectionView_.contentSize.width - tabHeaderCollectionView_.bounds.width)
        
        tabHeaderCollectionView_.setContentOffset(
            CGPoint(x: finalContentOffsetX, y: 0),
            animated: !interactiveScroll
        )
        
        if let header = tabHeaderCollectionView_.cellForItem(at: indexPath(for: leftTab)) {
            delegate.tabCollectionView(self, transitioningColor: getTransitioningColor(delta: translationRatio), forHeader: header)
        }
        
        if let header = tabHeaderCollectionView_.cellForItem(at: indexPath(for: rightTab)) {
            delegate.tabCollectionView(self, transitioningColor: getTransitioningColor(delta: 1 - translationRatio), forHeader: header)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == kContentCollectionViewTag {
            let tab = Int(scrollView.contentOffset.x/scrollView.bounds.width)
            currentSelectedTab = tab
        }
    }
    
    //MARK: Private Methods
    private func getTransitioningColor(delta: CGFloat) -> UIColor {
        return Utils.getTransitioningColor(
            from: selectedHeaderColor,
            to: normalHeaderColor,
            delta: delta
        )
    }
    
    private func updateTabHeaderLayout() {
        // As this method is used in didSet of properties
        // Ignoring unneccessory layout update calls before moving to window
        // This method should be called at layoutSubviews instead
        if window == nil { return }
        
        let tabHeaderHeight = isTabHeaderHidden ? 0 : self.tabHeaderHeight
        tabHeaderSeperatorLineView.isHidden = isTabHeaderHidden
        
        tabHeaderHeightConstraint?.constant = tabHeaderHeight
        tabHeaderSeparatorLineTopConstraint?.constant = tabHeaderHeight + (kTabIndicatorHeight/2)
        
        tabHeaderCollectionView_.reloadData()
    }
    
    private func reloadTabIndicatorView() {
        // As this method is used in didSet of properties
        // Ignoring unneccessory layout update calls before moving to window
        // This method should be called at layoutSubviews instead
        if window == nil { return }
        
        tabIndicatorView.isHidden = isTabHeaderHidden
        tabIndicatorView.frame.size = CGSize(
            width: headerWidth(at: currentSelectedTab) - (2*kTabIndicatorPadding),
            height: kTabIndicatorHeight
        )
        tabIndicatorView.frame.origin.x = getTabIndicatorViewXValue()
        tabIndicatorView.frame.origin.y = tabHeaderHeight
    }
    
    private func registerCellTypes() {
        guard let source = datasource else { return }
        headerCollectionView.register(source.tabHeaderCellType, forCellWithReuseIdentifier: kTabHeaderCellId)
        contentCollectionView.register(source.tabContentCellType, forCellWithReuseIdentifier: kContentCellId)
    }
    
    private func getTabIndicatorViewXValue() -> CGFloat {
        if let attributes = tabHeaderCollectionView_.layoutAttributesForItem(at: indexPath(for: currentSelectedTab)) {
            return attributes.frame.minX + kTabIndicatorPadding
        }
        return kTabIndicatorPadding
    }
    
    private func refreshScrollOffset() {
        contentCollectionView.contentOffset.x = contentCollectionView.bounds.width * CGFloat(currentSelectedTab)
    }
    
    private func indexPath(for item: Int) -> IndexPath {
        return IndexPath(item: item, section: 0)
    }
    
    //MARK: Views and Constraints
    private lazy var tabHeaderCollectionView_: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = kTabHeaderCollectionViewTag
        view.backgroundColor = .adaptiveBackground
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = false
        view.allowsSelection = true
        view.allowsMultipleSelection = false
        view.scrollsToTop = false
        return view
    }()
    
    private lazy var contentCollectionView_: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = kContentCollectionViewTag
        view.backgroundColor = .adaptiveBackground
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.scrollsToTop = false
        return view
    }()
    
    private lazy var tabHeaderSeperatorLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .adaptiveSeparator
        view.setConstantHeight(1)
        return view
    }()
    
    private lazy var tabIndicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = kTabIndicatorHeight/2
        view.backgroundColor = tintColor
        view.clipsToBounds = true
        return view
    }()

    private var tabHeaderHeightConstraint: NSLayoutConstraint?
    private var tabHeaderCollectionViewWidthConstraint: NSLayoutConstraint?
    private var tabHeaderSeparatorLineTopConstraint: NSLayoutConstraint?
    
    private func setupViews() {
        addSubview(tabHeaderSeperatorLineView)
        addSubview(tabHeaderCollectionView_)
        addSubview(contentCollectionView_)
        
        tabHeaderCollectionView_.addSubview(tabIndicatorView)
    }
    
    private func setupConstraints() {
        tabHeaderCollectionView_.safeTopAnchor()
        tabHeaderHeightConstraint = tabHeaderCollectionView_.setConstantHeight(tabHeaderHeight)
        tabHeaderCollectionViewWidthConstraint = tabHeaderCollectionView_.setConstantWidth(300)
        tabHeaderCollectionViewWidthConstraint?.prioritize(.fittingSizeLevel)
        
        tabHeaderSeperatorLineView.fillSuperViewWidth(safeLayout: false)
        tabHeaderSeparatorLineTopConstraint = tabHeaderSeperatorLineView.anchorTop(padding: tabHeaderHeight + (kTabIndicatorHeight/2))
        
        contentCollectionView_.fillSuperViewWidth()
        contentCollectionView_.placeBelow(view: tabHeaderCollectionView_, padding: kTabIndicatorHeight)
        contentCollectionView_.safeBottomAnchor()
    }
    
    private var headerAlignmentActiveConstraints: [NSLayoutConstraint] = []
    
    private func getLayoutGuide() -> UILayoutGuide {
        return tabHeaderFollowsReadableLayoutGuide ? readableContentGuide : safeAreaLayoutGuide
    }
    
    private func getHeaderViewAlignmentConstraints() -> [NSLayoutConstraint] {
        return getHeaderViewXAxisConstraints() + getHeaderViewHuggingWidthConstraint()
    }
    
    private func getHeaderViewHuggingWidthConstraint() -> [NSLayoutConstraint] {
        let layoutGuide = getLayoutGuide()
        return [tabHeaderCollectionView_.widthAnchor.constraint(lessThanOrEqualTo: layoutGuide.widthAnchor)]
    }
    
    private func getHeaderViewXAxisConstraints() -> [NSLayoutConstraint] {
        switch headerAlignment {
        case .leading: return getLeadingAlignedConstraints()
        case .left: return getLeftAlignedConstraints()
        case .center: return getCenterAlignedConstraints()
        case .trailing: return getTrailingAlignedConstraints()
        case .right: return getRightAlignedConstraints()
        }
    }
    
    private func updateHeaderViewWidthConstraint() {
        let contentWidth = tabHeaderCollectionView_.contentSize.width
        let layoutGuideWidth = getLayoutGuide().layoutFrame.width
        let calcWidth = contentWidth > layoutGuideWidth ? layoutGuideWidth : contentWidth
        tabHeaderCollectionViewWidthConstraint?.constant = calcWidth
    }
    
    private func getLeadingAlignedConstraints() -> [NSLayoutConstraint] {
        let layoutGuide = getLayoutGuide()
        return [tabHeaderCollectionView_.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor)]
    }
    
    private func getCenterAlignedConstraints() -> [NSLayoutConstraint] {
        let layoutGuide = getLayoutGuide()
        return [tabHeaderCollectionView_.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor)]
    }
    
    private func getTrailingAlignedConstraints() -> [NSLayoutConstraint] {
        let layoutGuide = getLayoutGuide()
        return [tabHeaderCollectionView_.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)]
    }
    
    private func getLeftAlignedConstraints() -> [NSLayoutConstraint] {
        let layoutGuide = getLayoutGuide()
        return [tabHeaderCollectionView_.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor)]
    }
    
    private func getRightAlignedConstraints() -> [NSLayoutConstraint] {
        let layoutGuide = getLayoutGuide()
        return [tabHeaderCollectionView_.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor)]
    }
    
}
