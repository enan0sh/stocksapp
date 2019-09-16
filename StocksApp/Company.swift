//
//  Company.swift
//  StocksApp
//
//  Created by Nahir Gamaliel Haro Sanchez on 9/16/19.
//  Copyright © 2019 Nahir Gamaliel Haro Sanchez. All rights reserved.
//

import Foundation

class Company {
    let symbol: String?
    let name: String?
    var sector: String?
    var currentStockValue: Double?
    var weeklyStockValue: [Double]?
    
    init(_ symbol:String, name:String, sector:String, currentStockValue:Double, weeklyStockValue:[Double]) {
        self.symbol = symbol
        self.name = name
        self.sector = sector
        self.currentStockValue = currentStockValue
        self.weeklyStockValue = weeklyStockValue
    }
    
    init(withOnlyEssentials symbol:String, name:String) {
        self.symbol = symbol
        self.name = name
    }
    
}
