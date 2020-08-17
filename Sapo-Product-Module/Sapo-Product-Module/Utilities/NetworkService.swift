//
//  NetworkService.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/6/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    let base_URL = "https://interndev.mysapo.vn/admin"
    
    var page = 1
    var limit = 30
    var category = ""
    func setCategory(category: Category) {
        self.category = ""
        if let category = category.id {
             self.category = "?category_ids=\(category)"
        }
       
    }
    
    func setPage(page: Int) {
        self.page = page
    }
    
    func setLimit(limit: Int) {
        self.limit = limit
    }
    
    func buildURL() -> String {
        return base_URL + "/products.json" + "?page=\(page)" + "&limit=\(limit)"
    }
    
    func getProduct(onSucess: @escaping (ResultProduct) -> Void, onError: @escaping (String) -> Void) {
        
        let source = base_URL + "/products.json" + category
        
        guard let url = URL(string: source) else {
            return
        }
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue( "919b6923dae8421cfda6dffdc5a669f7", forHTTPHeaderField:"X-Sapo-SessionId")
        let task = session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                onError("Invalid data")
                return
            }
            
            if response.statusCode == 200 {
                let rs = try! JSONDecoder().decode(ResultProduct.self, from: data)
                DispatchQueue.main.async {
                    onSucess(rs)
                }
                
            } else {
                onError("Not 200")
            }
         
            
        }
        task.resume()
    }
    
    func getCategory(onSucess: @escaping (ResultCategory) -> Void, onError: @escaping (String) -> Void) {
        guard let url = URL(string: base_URL + "/categories.json") else {
            return
        }
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue( "919b6923dae8421cfda6dffdc5a669f7", forHTTPHeaderField:"X-Sapo-SessionId")
        let task = session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                onError("Invalid data")
                return
            }
            
            if response.statusCode == 200 {
                let rs = try! JSONDecoder().decode(ResultCategory.self, from: data)
                DispatchQueue.main.async {
                    onSucess(rs)
                }
                
            } else {
                onError("Not 200")
            }
         
            
        }
        task.resume()
    }
    
}


