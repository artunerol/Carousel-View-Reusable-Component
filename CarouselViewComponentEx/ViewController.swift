//
//  ViewController.swift
//  CarouselViewComponentEx
//
//  Created by Artun Erol on 27.12.2022.
//

import UIKit

class ViewController: UIViewController {
    let viewModel = ViewModel()
    
    @IBOutlet var carouselView: NewCarouselView! {
        didSet {
            carouselView.expandableSource = self
            carouselView.actionSource = self
        }
    }
    
    @IBOutlet var carouselHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCarouselView()
    }
    
    private func configureCarouselView() {
        carouselView.configure(items: viewModel.carouselCellItems, cellIdentifier: CustomCarouselCell.reuseIdentifier)
    }
}

// MARK: - CarouselCellAction
extension ViewController: CarouselCellActionSource {
    func carouselCellAction(with data: CarouselCellModel?) {
        guard let data = data as? CustomCarouselCellModel else { return }
        let amount = data.amount ?? ""
        print("Amount of Current cell is \(amount)")
    }
}

// MARK: - Expandable Carousel
extension ViewController: ExpandableCarousel {
    func expandCarousel(isExpand: Bool) {
        if isExpand {
            carouselHeight.constant = 400
            carouselView.expandAllCarouselCells(isExpand)
            carouselView.layoutIfNeeded()
        } else {
            carouselHeight.constant = 250
            carouselView.expandAllCarouselCells(isExpand)
            carouselView.layoutIfNeeded()
        }
    }
}
// MARK: - ViewModel
class ViewModel {
    let carouselCellItems = [
    CustomCarouselCellModel(
        title: "Deniz Bonus Klasik Trink",
        secondaryTitle: "4090 70** **** 0570",
        amountTitle: "Kullanılabilir Limit",
        amount: "13000.00"),
    CustomCarouselCellModel(
        title: "Banka Kartım",
        secondaryTitle: nil,
        amountTitle: "Bakiyem",
        amount: "15.00"),
    CustomCarouselCellModel(
        title: "Ödemelerim",
        secondaryTitle: nil,
        amountTitle: "Ödeme Tutarım",
        amount: "5000.00"),
    ]
}

