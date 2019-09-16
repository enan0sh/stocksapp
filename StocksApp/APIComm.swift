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
                            if !self.topGainers.isEmpty {
                                self.topGainers.removeAll()
                            }
                            for item in json{
                                if let dictItem = item as? [String: Any] {
                                    if let symbol = dictItem["symbol"] as? String, let name = dictItem["companyName"] as? String {
                                        self.topActive.append(Company(withOnlyEssentials: symbol, name: name))
                                    }
                                }
                            }
                        } else {
                            print("Error parsing JSON.")
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
