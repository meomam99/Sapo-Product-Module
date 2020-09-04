//
//  InventoryInformationView.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/21/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ProductInventoryView: UIView {

    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbOnHand: UILabel!
    @IBOutlet weak var lbRetailPrice: UILabel!
    @IBOutlet weak var lbWholePrice: UILabel!
    @IBOutlet weak var lbImportPrice: UILabel!
    @IBOutlet weak var lbTaxable: UILabel!
    @IBOutlet weak var imgTaxable: UIImageView!
    @IBOutlet weak var btnInventoryInfo: UIButton!
    @IBOutlet weak var btnPriceInfo: UIButton!

    
    override func awakeFromNib() {
        setupView()
    }

    func setupView() {
        self.layer.setBorderSilver()
    }
    
    func setData(variant: Variant) {
        lbRetailPrice.text = variant.getRetailPrice()
        lbWholePrice.text = variant.getWholePrice()
        lbImportPrice.text = variant.getImportPrice()
        lbOnHand.text = variant.inventories[0].on_hand.toString()
        if variant.taxable {
            imgTaxable.tintColor = .systemGreen
            imgTaxable.image = UIImage(systemName: "checkmark.circle")
            lbTaxable.text = "Có áp dụng thuế"
        } else {
            imgTaxable.image = UIImage(systemName: "xmark.circle")
            imgTaxable.tintColor = .systemRed
            lbTaxable.text = "Không áp dụng thuế"
        }
    }
    
}
