//
//  Company.swift
//  StocksApp
//
//  Created by Nahir Gamaliel Haro Sanchez on 9/16/19.
//  Copyright © 2019 Nahir Gamaliel Haro Sanchez. All rights reserved.
//

import Foundation

class Company {
    var symbol: String?
    var name: String?
    var sector: String?
    var weeklyStockValue: [dateAndValue]?
    
    init(_ symbol:String, name:String, sector:String, weeklyStockValue:[dateAndValue]) {
        self.symbol = symbol
        self.name = name
        self.sector = sector
        self.weeklyStockValue = weeklyStockValue
    }
    
    init(withOnlyEssentials symbol:String, name:String) {
        self.symbol = symbol
        self.name = name
    }
}

struct dateAndValue {
    var date: String
    var value: Double
}
