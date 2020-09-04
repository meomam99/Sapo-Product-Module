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
    let session = URLSession(configuration: .default)
    var request: URLRequest!
    var page = 1
    var limit = 20
    var keyword = ""

    func configSession(method: String, source: String) {
        guard let url = URL(string: source) else {
            return
        }
        request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = [
            "X-Sapo-SessionId": "919b6923dae8421cfda6dffdc5a669f7",
            "X-Sapo-LocationId": "314486",
            "Content-Type": "application/json"
        ]
        
    }
    
    func setCategory(category_id: Int?) -> String {
        
        if let category_id = category_id {
            return "\(category_id)"
        } else { return "" }
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
    
    func AddProduct(product: ProductPost, onSucess: @escaping (Product) -> Void, onError: @escaping (String) -> Void) {
        let source = base_URL + "/products.json"
        
        configSession(method: "POST", source: source)
        guard let json = try? JSONEncoder().encode(product) else {
            print("Error on encode")
            return
        }
        request.httpBody = json
        print(String(decoding: json, as: UTF8.self))
        let task = session.uploadTask(with: request, from: json) { (responseData, response, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            
            guard let data = responseData, let response = response as? HTTPURLResponse else {
                onError("Invalid data")
                
                return
            }
            DispatchQueue.main.async {
                if response.statusCode == 201 {
                    let rs = try! JSONDecoder().decode(ResultProductById.self, from: data)
                    onSucess(rs.product)
                } else if response.statusCode == 422 {
                    let rs = try! JSONDecoder().decode(ResultError.self, from: data)
                    var s = ""
                    for key in rs.data_error.errors.keys {
                        s += key + ": " + (rs.data_error.errors[key] ?? "") + "\n"
                    }
                    onError(s)
                    
                } else {
                    onError("\(response.statusCode)")
                }
            }
        }
        task.resume()
    }
    
    func AddVariant(product_id:Int, variant: VariantPost, onSucess: @escaping (Variant) -> Void, onError: @escaping (String) -> Void) {
        let source = base_URL + "/products/\(product_id)/variants.json"
        
        configSession(method: "POST", source: source)
        guard let json = try? JSONEncoder().encode(variant) else {
            print("Error on encode")
            return
        }
        request.httpBody = json
        print(String(decoding: json, as: UTF8.self))
        let task = session.uploadTask(with: request, from: json) { (responseData, response, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            
            guard let data = responseData, let response = response as? HTTPURLResponse else {
                onError("Invalid data")
                
                return
            }
      
            DispatchQueue.main.async {
                if response.statusCode == 201 {
                    let rs = try! JSONDecoder().decode(ResultVariantById.self, from: data)
                    onSucess(rs.variant)
                    
                } else if response.statusCode == 422 {
                    let rs = try! JSONDecoder().decode(ResultError.self, from: data)
                    var s = ""
                    for key in rs.data_error.errors.keys {
                        s += key + ": " + (rs.data_error.errors[key] ?? "") + "\n"
                        onError(s)
                    }
                } else {
                    onError("\(response.statusCode)")
                }
            }
        }
        task.resume()
    }
    
    func editProduct(product_id:Int,  product: ProductPost, onSucess: @escaping (Product) -> Void, onError: @escaping (String) -> Void) {
        let source = base_URL + "/products/\(product_id).json"
        
        configSession(method: "PUT", source: source)
        guard let json = try? JSONEncoder().encode(product) else {
            print("Error on encode")
            return
        }
        request.httpBody = json
        print(String(decoding: json, as: UTF8.self))
        let task = session.uploadTask(with: request, from: json) { (responseData, response, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            
            guard let data = responseData, let response = response as? HTTPURLResponse else {
                onError("Invalid data")
                
                return
            }
            DispatchQueue.main.async {
                if response.statusCode == 200 {
                    let rs = try! JSONDecoder().decode(ResultProductById.self, from: data)
                    onSucess(rs.product)
                } else if response.statusCode == 422 {
                    let rs = try! JSONDecoder().decode(ResultError.self, from: data)
                    var s = ""
                    for key in rs.data_error.errors.keys {
                        s += key + ": " + (rs.data_error.errors[key] ?? "") + "\n"
                        onError(s)
                    }
                } else {
                    onError("\(response.statusCode)")
                }
            }
        }
        task.resume()
    }
    
    
    func editVariant(product_id:Int, variant_id: Int, variant: VariantPost, onSucess: @escaping (Variant) -> Void, onError: @escaping (String) -> Void) {
        let source = base_URL + "/products/\(product_id)/variants/\(variant_id).json"
        
        configSession(method: "PUT", source: source)
        guard let json = try? JSONEncoder().encode(variant) else {
            print("Error on encode")
            return
        }
        request.httpBody = json
        print(String(decoding: json, as: UTF8.self))
        let task = session.uploadTask(with: request, from: json) { (responseData, response, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            
            guard let data = responseData, let response = response as? HTTPURLResponse else {
                onError("Invalid data")
                
                return
            }

            DispatchQueue.main.async {
                if response.statusCode == 200 {
                    let rs = try! JSONDecoder().decode(ResultVariantById.self, from: data)
                    onSucess(rs.variant)
                } else if response.statusCode == 422 {
                    let rs = try! JSONDecoder().decode(ResultError.self, from: data)
                    var s = ""
                    for key in rs.data_error.errors.keys {
                        s += key + ": " + (rs.data_error.errors[key] ?? "") + "\n"
                        onError(s)
                    }
                } else {
                    onError("\(response.statusCode)")
                }
            }
        }
        task.resume()
    }
    
    func getProduct(category_id: Int?, onSucess: @escaping (ResultProduct) -> Void, onError: @escaping (String) -> Void) {
        
        let category = NetworkService.shared.setCategory(category_id: category_id)
        
        let source = base_URL + "/products.json?category_ids=\(category)&page=\(page)&limit=\(limit)&query=\(keyword)"
        configSession(method: "GET", source: source)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("Invalid data")
                return
            }
            
            if response.statusCode == 200 {
                let rs = try! JSONDecoder().decode(ResultProduct.self, from: data)
                DispatchQueue.main.async {
                    onSucess(rs)
                }
                
            } else {
                DispatchQueue.main.async {
                      onError("Not 200")
                  }
                
            }
            
            
        }
        task.resume()
    }
    
    func getProductById(product_id: Int, onSucess: @escaping (ResultProductById) -> Void, onError: @escaping (String) -> Void) {
        
        let source = base_URL + "/products/\(product_id).json"
        
        configSession(method: "GET", source: source)

        let task = session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("Invalid data")
                return
            }
            
            if response.statusCode == 200 {
                let rs = try! JSONDecoder().decode(ResultProductById.self, from: data)
                DispatchQueue.main.async {
                    onSucess(rs)
                }
                
            } else {
                DispatchQueue.main.async {
                    onError("Not 200")
                }
                
            }
            
            
        }
        task.resume()
    }
    
    func getVariant(category_id: Int?, onSucess: @escaping (ResultVariant) -> Void, onError: @escaping (String) -> Void) {
        
        let category = NetworkService.shared.setCategory(category_id: category_id)
        
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
    
    func getVariantById(product_id: Int, variant_id: Int, onSucess: @escaping (ResultVariantById) -> Void, onError: @escaping (String) -> Void) {
        
        let source = base_URL + "/products/\(product_id)/variants/\(variant_id).json"
        
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
                
                let rs = try! JSONDecoder().decode(ResultVariantById.self, from: data)
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
    
    func getBrand(onSucess: @escaping (ResultBrand) -> Void, onError: @escaping (String) -> Void) {
        guard let url = URL(string: base_URL + "/brands.json") else {
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
                let rs = try! JSONDecoder().decode(ResultBrand.self, from: data)
                DispatchQueue.main.async {
                    onSucess(rs)
                }
                
            } else {
                onError("Not 200")
            }
            
            
        }
        task.resume()
    }
    
    func DeleteVariant(product_id: Int, variant_id: Int, onSucess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let source = base_URL + "/products/\(product_id)/variants/\(variant_id).json"

        configSession(method: "DELETE", source: source)
      
        let task = session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard let _ = data, let response = response as? HTTPURLResponse else {
                print("Invalid data")
                return
            }
            DispatchQueue.main.async {
                if response.statusCode == 200 {
                    onSucess()
                    
                } else if response.statusCode == 422 {
                    onError("Không thể xóa phiên bản duy nhất của sản phẩm")
                } else {
                    onError("Có lỗi  xảy, thử lại sau")
                }
            }
        }
        task.resume()
    }
    
    func DeleteProduct(product_id: Int, onSucess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let source = base_URL + "/products/\(product_id).json"
        configSession(method: "DELETE", source: source)

        let task = session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            guard let _ = data, let response = response as? HTTPURLResponse else {
                print("Invalid data")
                return
            }
            DispatchQueue.main.async {
                if response.statusCode == 200 {
                    onSucess()
                } else {
                    onError("Có lỗi xảy ra, thử lại sau")
                }
            }
        }
        task.resume()
    }
    
    func SetImageForVariant(product_id: Int, variant_id: Int,image: ImageForVariant, onSucess: @escaping (ResultVariantById) -> Void, onError: @escaping (String) -> Void) {
        let source = base_URL + "/products/\(product_id)/variants/\(variant_id).json"

        configSession(method: "PUT", source: source)
        
        guard let json = try? JSONEncoder().encode(image) else {
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
    
    func AddImageToProduct(product_id: Int, imageForProduct: ImageForProduct, onSucess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let source = base_URL + "/products/\(product_id)/images.json"
        
        configSession(method: "POST", source: source)
        guard let json = try? JSONEncoder().encode(imageForProduct) else {
            print("Error on encode")
            return
        }
        request.httpBody = json
        let task = session.uploadTask(with: request, from: json) { (responseData, response, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            
            guard let _ = responseData, let response = response as? HTTPURLResponse else {
                onError("Invalid data")
                return
            }
            //   print(String(decoding: data, as: UTF8.self))
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
    
    func DeleteImageFromProduct(product_id: Int,image_id: Int, onSucess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let source = base_URL + "/products/\(product_id)/images/\(image_id).json"
        
        configSession(method: "DELETE", source: source)
        let task = session.dataTask(with: request) { (_, response, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
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
    
}


