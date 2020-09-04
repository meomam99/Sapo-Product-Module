//
//  ProductNameView.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/21/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ProductNameView: UIView {
    
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbSKU: UILabel!
    @IBOutlet weak var lbBarcode: UILabel!
    @IBOutlet weak var lbWeight: UILabel!
    @IBOutlet weak var lbUnit: UILabel!
    @IBOutlet weak var lbOption1Key: UILabel!
    @IBOutlet weak var lbOption1Value: UILabel!
    @IBOutlet weak var lbOption2Key: UILabel!
    @IBOutlet weak var lbOption2Value: UILabel!
    @IBOutlet weak var lbOption3key: UILabel!
    @IBOutlet weak var lbOption3Value: UILabel!
    
    @IBOutlet weak var viewMore: UIView!
    
    @IBOutlet weak var viewOption1: UIView!
    @IBOutlet weak var viewOption2: UIView!
    @IBOutlet weak var viewOption3: UIView!
    
    override func awakeFromNib() {
        setupView()
    }

    func setupView() {
        viewMore.isHidden = true
        self.layer.setBorderSilver()
    }
    
    
    
    func setData(product: Product ) {
        viewMore.isHidden = true
        lbName.text = product.name
    }
    
    func setData(variant: Variant) {
        lbName.text = variant.name
        viewMore.isHidden = false
        lbSKU.text = variant.sku
        lbBarcode.text = variant.barcode
        lbWeight.text = variant.getWeight()
        lbUnit.text = variant.unit ?? ""
    }
    
    func showOption(variant: Variant, option1: String?, option2: String?, option3: String?) {
        
        viewOption1.isHidden = true
        viewOption2.isHidden = true
        viewOption3.isHidden = true
        
        guard let opt1 = variant.opt1 else {
            return
        }
        
        viewOption1.isHidden = false
        lbOption1Key.text = option1
        lbOption1Value.text = opt1
        
        guard let opt2 = variant.opt2 else {
            return
        }
        viewOption2.isHidden = false
        lbOption2Key.text = option2
        lbOption2Value.text = opt2
        
        guard let opt3 = variant.opt3 else {
            return
        }
        viewOption3.isHidden = false
        lbOption3key.text = option3
        lbOption3Value.text = opt3
        
    }
}
