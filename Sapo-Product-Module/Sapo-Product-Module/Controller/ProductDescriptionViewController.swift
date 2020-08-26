//
//  ProductDescriptionViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/19/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ProductDescriptionViewController: UIViewController {
    
    var desc:String?
    @IBOutlet weak var lbDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbDescription.numberOfLines = 10

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let desc = desc {
            lbDescription.text = desc
        } else {
            lbDescription.text = "Chưa có mô tả cho sản phẩm này !"
        }
        
    }
    


}
