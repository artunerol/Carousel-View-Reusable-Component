//
//  NewPreLoginCarouselView.swift
//  MobilDeniz-New
//
//  Created by Artun Erol on 13.11.2022.
//  Copyright © 2022 Intertech A.Ş. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NewCarouselView: UIView {
    var actionSource: CarouselCellActionSource?
    var expandableSource: ExpandableCarousel?
    private let disposeBag = DisposeBag()
    
    @IBOutlet var carouselCollectionView: CarouselCollectionView!
    
    @IBOutlet var pageControl: UIPageControl! {
        didSet {
            pageControl.isUserInteractionEnabled = false
        }
    }
    
    let carouselItems: BehaviorRelay<[CarouselCellModel]> = .init(value: [])
    let carouselCellIdentifier: BehaviorRelay<String> = .init(value: "")
    
    var cellData: CarouselCellModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(attachToNib())
        bindCollectionView()
    }
    
    func configure(items: [CarouselCellModel], cellIdentifier: String) {
        registerCells(with: cellIdentifier)
        carouselCellIdentifier.accept(cellIdentifier)
        
        carouselItems.accept(items)
        
        carouselCollectionView.registerActionSource(actionSource)
        carouselCollectionView.registerExpandableSource(expandableSource)
        
        bindPageControl()
    }
    
    func expandAllCarouselCells(_ isExpanded: Bool) {
        carouselCollectionView.expandCells(isExpanded)
    }
    
    func reloadCollectionView() {
        carouselCollectionView.reloadData()
    }
    
    private func registerCells(with identifier: String) {
        carouselCollectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
}

// MARK: - Bindings
extension NewCarouselView {
    private func bindCollectionView() {
        carouselItems
            .observeOn(MainScheduler.instance)
            .bind(to: carouselCollectionView.rx.items)
            .disposed(by: disposeBag)
        
        carouselCellIdentifier
            .observeOn(MainScheduler.instance)
            .bind(to: carouselCollectionView.rx.identifier)
            .disposed(by: disposeBag)
    }
    
    private func bindPageControl() {
        pageControl
            .rx
            .bindWithCollectionView(
                currentCellIndex: carouselCollectionView.currentCellIndex,
                numberOfPages: carouselItems.value.count,
                disposeBag: disposeBag)
    }
    
}

// MARK: - Nib Handler
extension NewCarouselView {
    func attachToNib() -> UIView {
        let view = loadViewFromNib()
        self.frame = bounds
        addSubview(view)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        return view
    }
    
    func loadViewFromNib() -> UIView {
        guard let view = UINib(nibName: "NewCarouselView", bundle: nil).instantiate(withOwner: self).first as? UIView else { return UIView(frame: .zero) }
        return view
    }
}
