//
//  ProductHomeViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/5/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ProductHomeViewController: UIViewController {

    @IBOutlet weak var addProductView: UIView!
    @IBOutlet weak var listProductView: UIView!
    @IBOutlet weak var importProductView: UIView!
    @IBOutlet weak var checkProductView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
   //     navigationController?.navigationBar.isHidden = true
        addProductView.layer.cornerRadius = 12

    }
    


}
