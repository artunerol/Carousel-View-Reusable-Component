//
//  CustomCarouselCellModel.swift
//  CarouselViewComponentEx
//
//  Created by Artun Erol on 27.12.2022.
//

import Foundation

class CustomCarouselCellModel: CarouselCellModel { //struct olarak yapılabilir.
    var title: String?
    var secondaryTitle: String?
    var amountTitle: String?
    var amount: String?
    
    init(title: String?, secondaryTitle: String?, amountTitle: String?, amount: String?) {
        self.title = title
        self.secondaryTitle = secondaryTitle
        self.amountTitle = amountTitle
        self.amount = amount
    }
}
