//
//  Model.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/5/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

struct ResultProduct: Codable {
    var metadata: Metadata
    var products: [Product]
}

struct Metadata: Codable {
    var total: Int
}

struct Product: Codable {
    var name: String
    var description: String?
    var brand: String?
    var category: String?
    var options: [Option]
    var images: [Image]
    var variants: [Variant]
    
    init() {
        name = ""
        description = ""
        brand = ""
        category = ""
        options = []
        images = []
        variants = []
    }

}

struct Option: Codable {
    var name: String
    var values: [String]
}

struct Image: Codable {
    var full_path: String
}

struct Variant: Codable{
    
    init() {
        variant_whole_price = 0
        variant_retail_price = 0
        name = ""
        product_name = ""
        opt1 = nil
        opt2 = nil
        opt3 = nil
        sku = ""
        status = ""
        description = ""
        images = [Image(full_path: "")]
        inventories = [Inventory(available: 0)]
    }
    
    var variant_whole_price: Double
    var variant_retail_price: Double
    var name: String
    var product_name: String
    var opt1: String?
    var opt2: String?
    var opt3: String?
    var sku: String
    var status: String
    var description: String?
    var images: [Image]?
    var inventories: [Inventory]
    
    func getName() -> String {
        var name = ""
        if let opt1 = self.opt1 {
            name = name + opt1
        }
        
        if let opt2 = self.opt2 {
            name = name + " - " + opt2
        }
        
        if let opt3 = self.opt3 {
            name = name + " - " + opt3
        }
        
       return name
    }
    
    func getInStock() -> Int {
        
        if self.inventories.count != 0 {
            return Int(self.inventories[0].available)
        }
        
        return 0
    }
    
}

struct Inventory: Codable {
    var available: Double
}

struct ResultCategory: Codable {
    var categories: [Category]

}

struct Category: Codable {
    init() {
        id = nil
        name = "Tất cả sản phẩm"
    }
    var id: Int?
    var name: String
}


extension Product {
    func getPriceInString(mode: Int) -> String {
        var price = 0
        if mode == 1 {
            price = Int(self.variants[0].variant_retail_price)
        } else {
            price = Int(self.variants[0].variant_whole_price)
        }
        var p: String = ""
        for i in 0..<"\(price)".count  {
               
            if(i != 0 && i%3 == 0) {
                p.append(".")
            }
            
             p.append("\(price)".reversed()[i])
        }
        let rs: String = (String) (p.reversed())
        return " \(rs) đ "
    }
    
    func getBrand() -> String {
        if let brand = self.brand {
            return brand
        } else {
            return "---"
        }
    }
    
    func getCategory() -> String {
        if let category = self.category {
            return category
        } else {
            return "---"
        }
    }
    
    func getDescription() -> String {
        if let desc = self.description {
            return desc
        } else {
            return "---"
        }
    }
    
    func getQuantity() -> Int{
        var sum = 0
        for i in self.variants {
            sum = sum + i.getInStock()
        }
        return sum
    }
    
}
