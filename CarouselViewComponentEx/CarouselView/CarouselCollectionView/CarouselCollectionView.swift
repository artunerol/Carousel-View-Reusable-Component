//
//  CarouselCollectionView.swift
//  MobilDeniz-New
//
//  Created by Artun Erol on 15.11.2022.
//  Copyright © 2022 Intertech A.Ş. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CarouselCollectionView: UICollectionView {
    var actionSource: CarouselCellActionSource?
    var expandableSource: ExpandableCarousel?
    var isAllCellsExpanded: Bool = false
    
    private var itemWidth: CGFloat {
        return self.frame.width - 32
    }
    
    private var itemHeigth: CGFloat {
        return self.frame.height
    }
    
    private let minimumLineSpacing: CGFloat = 8
    
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        let customFlowLayout = UICollectionViewFlowLayout()
        customFlowLayout.scrollDirection = .horizontal
        customFlowLayout.minimumLineSpacing = minimumLineSpacing
        customFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return customFlowLayout
    }
    
    var items: [CarouselCellModel] = []
    var cellReuseIdentifier: String = ""
    var currentCellIndex: BehaviorRelay<Int> = .init(value: 0)
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCollectionView()
    }
    
    func registerActionSource(_ source: CarouselCellActionSource?) {
        self.actionSource = source
        self.reloadData()
    }
    
    func registerExpandableSource(_ source: ExpandableCarousel?) {
        self.expandableSource = source
        self.reloadData()
    }
    
    func expandCells(_ isExpanded: Bool) {
        self.isAllCellsExpanded = isExpanded
        self.reloadData()
    }
}

// MARK: - UI Configurations
extension CarouselCollectionView {
    private func setupCollectionView() {
        self.delegate = self
        self.dataSource = self
        
        collectionViewLayout = collectionViewFlowLayout
        isScrollEnabled = true
        isPagingEnabled = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        backgroundColor = .clear
    }
}

// MARK: - CollectionView Delegate & DataSource & FlowLayout
extension CarouselCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? CarouselCell else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 8
        cell.actionSource = actionSource
        cell.expandableSource = expandableSource
        cell.toggleCellExpand(isAllCellsExpanded)
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: itemWidth, height: itemHeigth)
    }
}

// MARK: - ScrollView Delegate
extension CarouselCollectionView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let scrollVelocityThreshold = 0.5
        let itemArea = itemWidth + minimumLineSpacing
        var currentItemIndex = round(contentOffset.x / itemArea)
        let velocityX = velocity.x
        
        if velocityX > scrollVelocityThreshold {
            currentItemIndex += 1
        } else if velocityX < -scrollVelocityThreshold {
            currentItemIndex -= 1
        }
        
        let nearestPageOffset = currentItemIndex * itemArea
        
        targetContentOffset.pointee.x = nearestPageOffset
        scrollView.decelerationRate = .fast
        
        self.currentCellIndex.accept(Int(currentItemIndex))
    }
}
// MARK: - CarouselCell Protocols
protocol CarouselCell where Self: UICollectionViewCell {
    static var reuseIdentifier: String { get }
    var data: CarouselCellModel? { get set }
    
    var actionSource: CarouselCellActionSource? { get set }
    var expandableSource: ExpandableCarousel? { get set }
    func toggleCellExpand(_ isExpanded: Bool)
    
    func configure(with model: CarouselCellModel)
}

extension CarouselCell {
    func toggleCellExpand(_ isExpanded: Bool) { /* Empty Statement */}
}

protocol CarouselCellModel { /* Abstraction protocol */ }

// MARK: - Expandable Carousel Protocol

protocol ExpandableCarousel: AnyObject {
    func expandCarousel(isExpand: Bool)
}

// MARK: - Carousel Cell Action Protocol

protocol CarouselCellActionSource: AnyObject {
    func carouselCellAction(with data: CarouselCellModel?)
}

extension CarouselCellActionSource {
    func carouselCellAction(with data: CarouselCellModel? = nil) { /* Empty Statement */}
}
