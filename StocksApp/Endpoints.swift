//
//  Endpoints.swift
//  StocksApp
//
//  Created by Nahir Gamaliel Haro Sanchez on 9/16/19.
//  Copyright © 2019 Nahir Gamaliel Haro Sanchez. All rights reserved.
//

import Foundation

class Endpoints {
    static let TOP_GAINER = "/stock/market/list/gainers"
    static let TOP_ACTIVE = "/stock/market/list/mostactive"
    static let SEARCH_FREE = "/stock/$/company"
    static let SEARCH_PAID = ""
    static let KEY_LIST_LIMIT = "listLimit="
    static let HISTORIC_TRADE_VALUE_ONE_MONTH = "/stock/$/chart/1m"
    static let KEY_SIMPLIFY_CHART = "chartSimplify="
}
