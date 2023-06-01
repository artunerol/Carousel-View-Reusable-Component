//
//  CustomCarouselCell.swift
//  CarouselViewComponentEx
//
//  Created by Artun Erol on 27.12.2022.
//

import UIKit

class CustomCarouselCell: UICollectionViewCell, CarouselCell {
    static var reuseIdentifier: String = "CustomCarouselCell"
    var data: CarouselCellModel?
    
    @IBOutlet var title: UILabel!
    @IBOutlet var secondaryInfo: UILabel!
    @IBOutlet var amountTitle: UILabel!
    @IBOutlet var amount: UILabel!
    
    @IBOutlet var expandableContainer: UIView! {
        didSet {
            expandableContainer.isHidden = true
        }
    }
    @IBOutlet var expandButton: UIButton!
    
    var actionSource: CarouselCellActionSource?
    var expandableSource: ExpandableCarousel?
    
    var isCellExpanded: Bool = false
    
    func configure(with model: CarouselCellModel) {
        guard let model = model as? CustomCarouselCellModel else { return }
        title.text = model.title
        secondaryInfo.text = model.secondaryTitle
        amountTitle.text = model.amountTitle
        amount.text = model.amount
        data = model
    }
    
    @IBAction func expandButtonPressed(_ sender: Any) {
        expandableSource?.expandCarousel(isExpand: !isCellExpanded)
    }
    
    @IBAction func detailButtonPressed(_ sender: Any) {
        guard let data = data else { return }
        actionSource?.carouselCellAction(with: data)
    }
    
    func toggleCellExpand(_ isExpanded: Bool) {
        isCellExpanded = isExpanded
        toggleExpandUI()
    }
    
    private func toggleExpandUI() {
        if isCellExpanded {
            expandButton.setImage(ExpandableButtonImage.collapse.image(), for: .normal)
            expandableContainer.isHidden = !isCellExpanded
        } else {
            expandButton.setImage(ExpandableButtonImage.expand.image(), for: .normal)
            expandableContainer.isHidden = !isCellExpanded
        }
    }
}

// MARK: - Button Image Enum
fileprivate enum ExpandableButtonImage {
    case collapse
    case expand
    
    func image() -> UIImage? {
        switch self {
        case .collapse:
            return UIImage(named: "dashboard_summary_info_collapse")
        case .expand:
            return UIImage(named: "dashboard_summary_info_expand")
        }
    }
}
