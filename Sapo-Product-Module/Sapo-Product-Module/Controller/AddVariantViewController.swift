//
//  AddVariantViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/24/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class AddVariantViewController: UIViewController {

    var delegate: UpdateProduct?
    
    var variant: Variant?
    var isEditMode = false
    var isValid:Bool = true
    
    var opt1: String?
    var opt2: String?
    var opt3: String?
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var viewOpt1: UIView!
    @IBOutlet weak var viewOpt2: UIView!
    @IBOutlet weak var viewOpt3: UIView!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtSKU: UITextField!
    @IBOutlet weak var txtBarcode: UITextField!
    @IBOutlet weak var txtOption1: UITextField!
    @IBOutlet weak var txtOption2: UITextField!
    @IBOutlet weak var txtOption3: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtUnit: UITextField!
    @IBOutlet weak var txtOnHand: UITextField!
    @IBOutlet weak var txtRetailPrice: UITextField!
    @IBOutlet weak var txtWholePrice: UITextField!
    @IBOutlet weak var txtImportPrice: UITextField!
    
    @IBOutlet weak var swTaxable: UISwitch!
    @IBOutlet weak var swSellable: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: nil, action: nil)
        navigationController?.navigationItem.backBarButtonItem?.title = ""
        navigationController?.navigationItem.backBarButtonItem?.image = UIImage(systemName: "arrow.left")
    }
    
    func submit() {

    }
    
    func setupView() {
        setOption()
        view1.layer.setBorderSilver()
        view2.layer.setBorderSilver()
        view3.layer.setBorderSilver()
        txtName.AddBottomLine()
        txtSKU.AddBottomLine()
        txtBarcode.AddBottomLine()
        txtOnHand.AddBottomLine()
        txtOption1.AddBottomLine()
        txtOption2.AddBottomLine()
        txtOption3.AddBottomLine()
        txtWeight.AddBottomLine()
        txtUnit.AddBottomLine()
        txtWholePrice.AddBottomLine()
        txtRetailPrice.AddBottomLine()
        txtImportPrice.AddBottomLine()
        
    }
    
    func setOption() {
        
        //Default
        viewOpt1.isHidden = true
        viewOpt2.isHidden = true
        viewOpt3.isHidden = true
        
        //Option 1
        if let opt1 = self.opt1 {
            viewOpt1.isHidden = false
            txtOption1.placeholder = opt1
        } else {
            return
        }
        
        //Option 2
        if let opt2 = self.opt2 {
            viewOpt2.isHidden = false
            txtOption2.placeholder = opt2
        } else {
            return
        }
        
        // Option 3
        if let opt3 = self.opt3 {
            viewOpt3.isHidden = false
            txtOption3.placeholder = opt3
        } else {
            return
        }
        
    }
    

}
