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
    var id: Int
    var status: String
    var name: String
    var description: String?
    var brand: String?
    var category: String?
    var opt1: String?
    var opt2: String?
    var opt3: String?
    var options: [Option]
    var images: [Image]
    var variants: [Variant]
    
    init() {
        id = 0
        status = ""
        name = ""
        description = ""
        brand = ""
        category = ""
        opt1 = ""
        opt2 = ""
        opt3 = ""
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
    init() {
        id = 0
        full_path = ""
    }
    var id: Int
    var full_path: String
}



struct Variant: Codable{
    
    init() {
        id = 0
        product_id = 0
        variant_whole_price = 0
        variant_retail_price = 0
        variant_import_price = 0
        name = ""
        product_name = ""
        opt1 = nil
        opt2 = nil
        opt3 = nil
        sku = ""
        barcode = ""
        status = ""
        sellable = true
        taxable = true
        weight_unit = ""
        weight_value = 0
        unit = ""
        description = ""
        images = [Image]()
        inventories = [Inventory(available: 0, on_hand: 0)]
    }
    var id: Int
    var product_id: Int
    var variant_whole_price: Double
    var variant_retail_price: Double
    var variant_import_price: Double
    var name: String
    var product_name: String
    var opt1: String?
    var opt2: String?
    var opt3: String?
    var sku: String
    var barcode: String
    var status: String
    var taxable: Bool
    var sellable: Bool
    var weight_value: Double?
    var weight_unit: String?
    var unit: String?
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
    
    func getWeight() -> String {
        guard let unit = self.weight_unit,let value = self.weight_value else {
            return ""
        }
        let intValue = Int(value)
        return "\(intValue)" + unit
    }
    
}

struct Inventory: Codable {
    var available: Double
    var on_hand: Double
}

struct ResultCategory: Codable {
    var categories: [Category]

}

struct ResultVariant: Codable {
    var metadata: Metadata
    var variants: [Variant]
}

struct ResultProductById: Codable {
    var product: Product
}

struct ResultVariantById: Codable {
    var variant: Variant
}

struct ImageForVariant: Codable {
    init() {
        image_id = 0
    }
    var image_id: Int
}

struct ImageForProduct: Codable {
    init() {
        image = Base64(base64: "")
    }
    var image: Base64
}

struct Base64: Codable {
    var base64: String
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
    
    func getQuantity() -> Int {
        var sum = 0
        for i in self.variants {
            sum = sum + i.getInStock()
        }
        return sum
    }
    
}

extension Double {
    func toString() -> String {
        let price = "\(Int(self))"
        var p: String = ""
        for i in 0..<price.count  {
               
            if(i != 0 && i%3 == 0) {
                p.append(",")
            }
            
             p.append(price.reversed()[i])
        }
        let rs: String = (String) (p.reversed())
        return rs
    }
}
