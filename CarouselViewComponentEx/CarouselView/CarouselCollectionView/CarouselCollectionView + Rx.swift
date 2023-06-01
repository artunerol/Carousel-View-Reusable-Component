//
//  CarouselCollectionView + Rx.swift
//  MobilDeniz-New
//
//  Created by Artun Erol on 18.11.2022.
//  Copyright © 2022 Intertech A.Ş. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - PageControl Reactive Extension
extension Reactive where Base: UIPageControl {
    func bindWithCollectionView(currentCellIndex: BehaviorRelay<Int>, numberOfPages: Int, disposeBag: DisposeBag) {
        currentCellIndex
            .observeOn(MainScheduler.instance)
            .bind { cellIndex in
                self.numberOfPages.onNext(numberOfPages)
                self.currentPage.onNext(cellIndex)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CarouselView Reactive Extension
extension Reactive where Base: CarouselCollectionView {
    var items: Binder<[CarouselCellModel]> {
        return Binder(self.base) { owner, value in
            owner.items = value
            owner.reloadData()
        }
    }
    
    var identifier: Binder<String> {
        return Binder(self.base) { owner, identifier in
            owner.cellReuseIdentifier = identifier
        }
    }
}
