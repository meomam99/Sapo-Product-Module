//
//  ProductMoreInformationView.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/20/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ProductMoreInformationView: UIView {

    var category: String = ""
    var brand: String = ""
    var desc: String = ""
    
    @IBOutlet weak var viewMore: UIView!
    
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbBrand: UILabel!
    
    @IBOutlet weak var btnShowMoreInfo: UIButton!
    @IBOutlet weak var btnShowDescription: UIButton!
    
    @IBOutlet weak var viewSellable: ProductSellableView!

    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        btnShowMoreInfo.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        btnShowDescription.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        
        viewMore.isHidden = true
        viewSellable.isHidden = true

        self.layer.setBorderSilver()
 
        
    }
    
    func setData(product: Product) {
        lbCategory.text = product.getCategory()
        lbBrand.text = product.getBrand()
        lbDesc.text = product.getDescription()
        viewSellable.isHidden = true
        
    }
    
    @IBAction func showMoreInfo(_ sender: Any) {
        var img = "chevron.down"
        if viewMore.isHidden {
            img = "chevron.up"
        }

        self.btnShowMoreInfo.setImage(UIImage(systemName: img), for: .normal)
        self.viewMore.isHidden = !self.viewMore.isHidden
        
    }

}

class ProductSellableView: UIView {
    
    @IBOutlet weak var imgSellable: UIImageView!
    @IBOutlet weak var lbSellable: UILabel!
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        lbSellable.text = "Cho phép bán"
        imgSellable.image = UIImage(systemName: "checkmark.circle")
        imgSellable.tintColor = .systemGreen
        
    }
    
    func setData(sellable: Bool) {
        if sellable {
            lbSellable.text = "Cho phép bán"
            imgSellable.image = UIImage(systemName: "checkmark.circle")
            imgSellable.tintColor = .systemGreen
        } else {
            lbSellable.text = "Không cho phép bán"
            imgSellable.image = UIImage(systemName: "xmark.circle")
            imgSellable.tintColor = .red
        }
    }
}


