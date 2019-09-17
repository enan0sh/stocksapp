//
//  APIComm.swift
//  StocksApp
//
//  Created by Nahir Gamaliel Haro Sanchez on 9/16/19.
//  Copyright © 2019 Nahir Gamaliel Haro Sanchez. All rights reserved.
//

import Foundation

class APIComm {
    let PREFIX = "https://cloud.iexapis.com/stable"
    let PK_TOKEN = "pk_7bfddd057dba45eab98063c263aeb634"
    let TOKEN_PREFIX = "?token="
    private var topGainers = Array<Company>()
    private var topActive = Array<Company>()
    var currentCompany: Company?
    
    // NGSH Singleton aproach to use the same API Comm instance for the whole app. Need to manage memory correctly, remember not to instance again.
    static let singletonInstace = APIComm()
    
    
    func getTopGainers(withLimit limit:Int) -> Array<Company>{
        if topGainers.count <= 0 {
            updateTopGainers(withLimit: limit)
        }
        return topGainers
    }
    
    func getTopGainers() -> Array<Company>{
        if topGainers.count <= 0 {
            updateTopGainers(withLimit: 0)
        }
        return topGainers
    }
    
    func updateTopGainers(withLimit limit:Int) {
        var urlAPI  = PREFIX + Endpoints.TOP_GAINER + TOKEN_PREFIX + PK_TOKEN
        
        if limit != 0 {
            urlAPI += "&" + Endpoints.KEY_LIST_LIMIT + String(limit)
        }
        
        let urlString = URL(string: urlAPI)
        
        if let url = urlString {
            // NGSH using datatask for this one, hopping not to stop main thread.
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let responseData = data {
                        if let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [Any] {
                            // NGSH Parssing worked well, so now we delete the old info.
                            if !self.topGainers.isEmpty {
                                self.topGainers.removeAll()
                            }
                            for item in json{
                                if let dictItem = item as? [String: Any] {
                                    if let symbol = dictItem["symbol"] as? String, let name = dictItem["companyName"] as? String {
                                        self.topGainers.append(Company(withOnlyEssentials: symbol, name: name))
                                    }
                                }
                            }
                            NotificationCenter.default.post(name: Notification.Name.init(rawValue: Utilities.DATA_UPDATE_NOTIFICATION), object: nil)
                        } else {
                            print("Error parsing JSON.")
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    // NGSH Same API call as top gainers, but with most active companies.
    func getTopActive(withLimit limit:Int) -> Array<Company>{
        if topActive.count <= 0 {
            updateTopActive(withLimit: limit)
        }
        return topActive
    }
    
    func getTopActive() -> Array<Company>{
        if topActive.count <= 0 {
            updateTopActive(withLimit: 0)
        }
        return topActive
    }
    
    func updateTopActive(withLimit limit:Int) {
        var urlAPI  = PREFIX + Endpoints.TOP_ACTIVE + TOKEN_PREFIX + PK_TOKEN
        
        if limit != 0 {
            urlAPI += "&" + Endpoints.KEY_LIST_LIMIT + String(limit)
        }
        
        let urlString = URL(string: urlAPI)
        
        if let url = urlString {
            // NGSH using datatask for this one, hopping not to stop main thread.
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let responseData = data {
                        if let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [Any] {
                            // NGSH Parssing worked well, so now we delete the old info.
                            if !self.topActive.isEmpty {
                                self.topActive.removeAll()
                            }
                            for item in json{
                                if let dictItem = item as? [String: Any] {
                                    if let symbol = dictItem["symbol"] as? String, let name = dictItem["companyName"] as? String {
                                        self.topActive.append(Company(withOnlyEssentials: symbol, name: name))
                                    }
                                }
                            }
                            NotificationCenter.default.post(name: Notification.Name.init(rawValue: Utilities.DATA_UPDATE_NOTIFICATION_MOST_ACTIVE), object: nil)
                        } else {
                            print("Error parsing JSON.")
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func getDataCompany(withSymbol symbol:String) {
        let companyInfoURL = PREFIX + Endpoints.SEARCH_FREE.replacingOccurrences(of: "$", with: symbol) + TOKEN_PREFIX + PK_TOKEN
        let urlRequestAPI = URL(string: companyInfoURL)
        
        if let url = urlRequestAPI {
            // NGSH using datatask for this one, hopping not to stop main thread.
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let responseData = data {
                        if let json = try? JSONSerialization.jsonObject(with: responseData, options: []) {
                            // NGSH Json parsing went well.
                                if let dictItem = json as? [String: Any] {
                                    if let symbol = dictItem["symbol"] as? String, let name = dictItem["companyName"] as? String, let sector = dictItem["sector"] as? String{
                                        if self.currentCompany == nil {
                                            self.currentCompany = Company(withOnlyEssentials: symbol, name: name)
                                        }else {
                                            self.currentCompany?.name = name
                                            self.currentCompany?.symbol = symbol
                                        }
                                        self.currentCompany?.sector = sector
                                    }
                                }
                            
                            NotificationCenter.default.post(name: Notification.Name.init(rawValue: Utilities.PRIMARY_COMPANY_DATA_NOTIFICATION), object: nil)
                        } else {
                            print("Error parsing JSON.")
                        }
                    }
                }
            }
            task.resume()
        }
        
        let companyHistoryURL = PREFIX + Endpoints.HISTORIC_TRADE_VALUE_ONE_MONTH.replacingOccurrences(of: "$", with: symbol) + TOKEN_PREFIX + PK_TOKEN + "&" + Endpoints.KEY_SIMPLIFY_CHART + "true"
        let urlRequestHistoryAPI = URL(string: companyHistoryURL)

        if let url = urlRequestHistoryAPI {
            // NGSH using datatask for this one, hopping not to stop main thread.
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let responseData = data {
                        if let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [Any] {
                            var dictHistroy = Array<dateAndValue>()
                            // NGSH Json parsing went well.
                            for item in json {
                                if let dictItem = item as? [String: Any] {
                                    if let changePorcent = dictItem["changePercent"] as? Double, let date = dictItem["date"] as? String {
                                        dictHistroy.append(dateAndValue(date: date, value: changePorcent))
                                    }
                                }
                                if dictHistroy.count > 7 {
                                    break;
                                }
                            }
                            if self.currentCompany == nil {
                                self.currentCompany = Company(withOnlyEssentials: "", name: "")
                            }
                            dictHistroy.sort { (ls: dateAndValue, rs: dateAndValue) -> Bool in
                                return ls.date.compare(rs.date) == .orderedAscending
                            }
                            self.currentCompany?.weeklyStockValue = dictHistroy
                            NotificationCenter.default.post(name: Notification.Name.init(rawValue: Utilities.SECUNDARY_COMPANY_DATA_NOTIFICATION), object: nil)
                        } else {
                            print("Error parsing JSON.")
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func existSymbol(_ symbol:String) {
        let companyInfoURL = PREFIX + Endpoints.SEARCH_FREE.replacingOccurrences(of: "$", with: symbol) + TOKEN_PREFIX + PK_TOKEN
        let urlRequestAPI = URL(string: companyInfoURL)
        
        if let url = urlRequestAPI {
            // NGSH using datatask for this one, hopping not to stop main thread.
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let responseData = data {
                        if let json = try? JSONSerialization.jsonObject(with: responseData, options: []) {
                            // NGSH Json parsing went well.
                            NotificationCenter.default.post(name: Notification.Name.init(rawValue: Utilities.SYMBOL_FOUND_NOTIFICATION), object: nil)
                        } else {
                            if let httpResponse = response as? HTTPURLResponse {
                                if httpResponse.statusCode == 404 {
                                    NotificationCenter.default.post(name: Notification.Name.init(rawValue: Utilities.SYMBOL_NOT_FOUND_NOTIFICATION), object: nil)
                                }
                            }
                            print("Error parsing JSON.")
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
