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
    var limit = 20
    var category = ""
    var keyword = ""
    var variant_id = 0
    var product_id = 0
    var imageForVariant = ImageForVariant()
    var imageForProduct = ImageForProduct()
    
    func SetImageForVariant(image: Image) {
        self.imageForVariant.image_id = image.id
    }
    
    func SetImageForProduct(image: String) {
        self.imageForProduct.image.base64 = image
    }
    
    func setCategory(category: Category) {
        if let category_id = category.id {
             self.category = "\(category_id)"
        } else {
            self.category = ""
        }
       
    }
    
    func setKeyword(key: String?) {
        if let key = key {
            self.keyword = key
        } else {
            self.keyword = ""
        }
    }
    
    func setPage(page: Int) {
        self.page = page
    }
    
    func setLimit(limit: Int) {
        self.limit = limit
    }
    
    func setVariantId(variant_id: Int) {
        self.variant_id = variant_id
    }
    
    func setProductId(product_id: Int) {
        self.product_id = product_id
    }
    
    func buildURL() -> String {
        return base_URL + "/products.json" + category + keyword
    }
    
    func getProduct(onSucess: @escaping (ResultProduct) -> Void, onError: @escaping (String) -> Void) {
        
       let source = base_URL + "/products.json?category_ids=\(category)&page=\(page)&limit=\(limit)&query=\(keyword)"
        
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
    
    func getProductById(onSucess: @escaping (ResultProductById) -> Void, onError: @escaping (String) -> Void) {
           
          let source = base_URL + "/products/\(product_id).json"
           
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
              
                   let rs = try! JSONDecoder().decode(ResultProductById.self, from: data)
                   DispatchQueue.main.async {
                       onSucess(rs)
                   }
            
               } else {
                   onError("Not 200")
               }
            
               
           }
           task.resume()
       }
    
    func getVariant(onSucess: @escaping (ResultVariant) -> Void, onError: @escaping (String) -> Void) {
        
       let source = base_URL + "/variants.json?category_ids=\(category)&page=\(page)&limit=\(limit)&query=\(keyword)"
        
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
                let rs = try! JSONDecoder().decode(ResultVariant.self, from: data)
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
    
    func DeleteVariant(onSucess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let source = base_URL + "/products/\(product_id)/variants/\(variant_id).json"
        guard let url = URL(string: source) else {
            onError("Có lỗi xảy ra, vui lòng thử lại sau !")
            return
        }
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("919b6923dae8421cfda6dffdc5a669f7", forHTTPHeaderField:"X-Sapo-SessionId")
        request.addValue("314486", forHTTPHeaderField:"X-Sapo-LocationId")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            
            guard let _ = data, let response = response as? HTTPURLResponse else {
                onError("Invalid data")
                return
            }
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    onSucess()
                }
                
            } else {
                onError("Not 200")
            }
        }
        task.resume()
    }
    
    func DeleteProduct(onSucess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let source = base_URL + "/products/\(product_id).json"
        guard let url = URL(string: source) else {
            onError("Có lỗi xảy ra, vui lòng thử lại sau !")
            return
        }
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("919b6923dae8421cfda6dffdc5a669f7", forHTTPHeaderField:"X-Sapo-SessionId")
        request.addValue("314486", forHTTPHeaderField:"X-Sapo-LocationId")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            
            guard let _ = data, let response = response as? HTTPURLResponse else {
                onError("Invalid data")
                return
            }
            
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    onSucess()
                }
                
            } else {
                onError("Not 200")
            }
        }
        task.resume()
    }
    
    func SetImageForVariant(onSucess: @escaping (ResultVariantById) -> Void, onError: @escaping (String) -> Void) {
        let source = base_URL + "/products/\(product_id)/variants/\(variant_id).json"
        guard let url = URL(string: source) else {
            onError("Có lỗi xảy ra, vui lòng thử lại sau !")
            return
        }
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "X-Sapo-SessionId": "919b6923dae8421cfda6dffdc5a669f7",
            "X-Sapo-LocationId": "314486",
            "Content-Type": "application/json"
            
        ]

        guard let json = try? JSONEncoder().encode(self.imageForVariant) else {
            print("Error on encode")
            return
        }
        request.httpBody = json
        let task = session.uploadTask(with: request, from: json) { (data, response, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                onError("Invalid data")
                return
            }
            
            if response.statusCode == 200 {
                let rs = try! JSONDecoder().decode(ResultVariantById.self, from: data)
                DispatchQueue.main.async {
     
                    onSucess(rs)
                    
                }
                
            } else {
                onError("Not 200, is was \(response.statusCode)")
            }
        }
        task.resume()
    }
    
    func AddImageToProduct(onSucess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let source = base_URL + "/products/\(product_id)/images.json"
        guard let url = URL(string: source) else {
            onError("Có lỗi xảy ra, vui lòng thử lại sau !")
            return
        }
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "X-Sapo-SessionId": "919b6923dae8421cfda6dffdc5a669f7",
            "X-Sapo-LocationId": "314486",
            "Content-Type": "application/json"
        ]
        guard let json = try? JSONEncoder().encode(self.imageForProduct) else {
            print("Error on encode")
            return
        }
        request.httpBody = json
        let task = session.uploadTask(with: request, from: json) { (responseData, response, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            
            guard let data = responseData, let response = response as? HTTPURLResponse else {
                onError("Invalid data")
                return
            }
            print(String(decoding: data, as: UTF8.self))
            if response.statusCode == 201 {
                DispatchQueue.main.async {
                    onSucess()
                }
                
            } else {
                onError("\(response.statusCode)")
            }
        }
        task.resume()
    }
    
}


