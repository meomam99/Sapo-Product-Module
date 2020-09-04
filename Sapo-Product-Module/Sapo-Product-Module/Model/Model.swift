//
//  Model.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/5/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import UIKit

struct ResultError: Codable {
    var data_error: DataError
}
struct DataError: Codable {
    var status: Int
    var errors: [String:String]
}

struct ResultProduct: Codable {
    var metadata: Metadata
    var products: [Product]
}

struct ResultBrand: Codable {
    var metadata: Metadata
    var brands: [Brand]
}

struct Metadata: Codable {
    var total: Int
}

struct Brand: Codable {
    var name: String?
}

struct Product: Codable {
    var id: Int
    var status: String
    var brand: String?
    var description: String?
    var name: String
    var opt1: String?
    var opt2: String?
    var opt3: String?
    var category_id: Int?
    var category: String?
    var variants: [Variant]
    var options: [Option]
    var images: [Image]
    
    
    init() {
        id = 0
        status = ""
        name = ""
        description = ""
        brand = ""
        category_id = 0
        category = ""
        opt1 = "Kích thước"
        opt2 = ""
        opt3 = ""
        options = []
        images = []
        variants = []
    }

}

struct Option: Codable {
    var name: String?
    var values: [String?]
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
        init_price = 0
        init_stock = 0
        variant_retail_price = 0
        variant_whole_price = 0
        variant_import_price = 0
        description = ""
        name = ""
        opt1 = "Mặc định"
        opt2 = nil
        opt3 = nil
        product_name = ""
        status = ""
        sellable = true
        sku = ""
        barcode = ""
        taxable = true
        weight_value = 0
        weight_unit = ""
        unit = ""
        inventories = []
        images = []
        variant_prices = []
    }
    var id: Int
    var product_id: Int
    var init_price: Double?
    var init_stock: Double?

    var variant_whole_price: Double?
    var variant_retail_price: Double?
    var variant_import_price: Double?
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
    var variant_prices: [Variant_Price]
    
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
    
    func getRetailPrice() -> String {
        if let price = self.variant_retail_price {
            return price.toString()
        }
        return "0"
    }
    func getWholePrice() -> String {
        if let price = self.variant_whole_price {
            return price.toString()
        }
        return "0"
    }
    func getImportPrice() -> String {
        if let price = self.variant_import_price {
            return price.toString()
        }
        return "0"
    }
    
}

struct Variant_Price: Codable {
    
    init() {
        value = 0
        price_list_id = 0
    }
    
    init(id: Int, value: Double) {
        self.value = value
        self.price_list_id = id
    }
    
    init(id: Int, value: String) {
        if let v:Double = Double(value) {
            self.value = v
        } else {
            self.value = 0
        }
        self.price_list_id = id
    }
    
    var value: Double
    var price_list_id: Int
    
}

struct Inventory: Codable {
    init() {
        location_id = 314486
     //   init_stock = 0
        available = 0
        on_hand = 0
        incoming = 0
        onway = 0
    }
    var location_id: Int
    var available: Double
    var on_hand: Double
    var incoming: Double
    var onway: Double
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

    init(image_id: Int) {
        self.image_id = image_id
    }
     var image_id: Int
}

struct ImageForProduct: Codable {
    init() {
        image = Base64(base64: "")
    }
    
    init(strbase64: String) {
        image = Base64(base64: strbase64)
    }
    
    var image: Base64
}

struct ProductPost:Codable {
    init() {
        product = Product()
    }
    init(product: Product) {
        self.product = product
    }
    var product: Product
}

struct VariantPost: Codable {
    init(variant: Variant) {
        self.variant = variant
    }
    init() {
        variant = Variant()
    }
    var variant: Variant
}

struct Base64: Codable {
    var base64: String
}

struct Category: Codable {
    init() {
        id = nil
        name = "Tất cả sản phẩm"
    }
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name ?? ""
    }
    var id: Int?
    var name: String
}


extension Product {
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
            if desc != "" {
                return desc
            }
        }
        return "---"
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
