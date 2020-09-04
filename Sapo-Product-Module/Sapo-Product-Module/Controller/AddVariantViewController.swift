//
//  AddVariantViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/24/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

enum editMode {
    case add
    case edit
    case editOnInit
}

class AddVariantViewController: UIViewController, UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
    var productDelegate: UpdateProductDelegate?
    var variantDelegate: UpdateVariantDelegate?
    var product_id = 0
    var variant: Variant = Variant()
    var editMode:editMode = .add
    var status = "true"
    
    var opt1: String?
    var opt2: String?
    var opt3: String?
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var viewOpt1: UIView!
    @IBOutlet weak var viewOpt2: UIView!
    @IBOutlet weak var viewOpt3: UIView!
    @IBOutlet weak var viewInitValue: UIView!
    
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtSKU: CustomTextField!
    @IBOutlet weak var txtBarcode: CustomTextField!
    @IBOutlet weak var txtOption1: CustomTextField!
    @IBOutlet weak var txtOption2: CustomTextField!
    @IBOutlet weak var txtOption3: CustomTextField!
    @IBOutlet weak var txtWeight: CustomTextField!
    @IBOutlet weak var txtUnit: CustomTextField!
    @IBOutlet weak var txtOnHand: CustomTextField!
    @IBOutlet weak var txtCostPrice: CustomTextField!
    @IBOutlet weak var txtRetailPrice: CustomTextField!
    @IBOutlet weak var txtWholePrice: CustomTextField!
    @IBOutlet weak var txtImportPrice: CustomTextField!
    
    @IBOutlet weak var btnOK: UIButton!
    
    @IBOutlet weak var swTaxable: UISwitch!
    @IBOutlet weak var swSellable: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    
    func setupView() {
        setOption()
        if editMode == .add {
            self.title = "Thêm phiên bản"
             viewInitValue.isHidden = false
        } else if editMode == .edit {
            self.title = "Sửa phiên bản"
             viewInitValue.isHidden = true
            self.fillupTextField()
        } else {
            self.title = variant.getName()
            viewInitValue.isHidden = false
            self.fillupTextField()
        }
        txtName.delegate = self
        txtSKU.delegate = self
        txtBarcode.delegate = self
        txtOption1.delegate = self
        txtOption2.delegate = self
        txtOption3.delegate = self
        txtWeight.delegate = self
        txtUnit.delegate = self
        txtCostPrice.delegate = self
        txtImportPrice.delegate = self
        txtRetailPrice.delegate = self
        txtWholePrice.delegate = self
        btnOK.layer.cornerRadius = 8
        view1.layer.setBorderSilver()
        view2.layer.setBorderSilver()
        view3.layer.setBorderSilver()
        txtCostPrice.addDoneButton()
        txtImportPrice.addDoneButton()
        txtWeight.addDoneButton()
        txtWholePrice.addDoneButton()
        txtRetailPrice.addDoneButton()
        txtOnHand.addDoneButton()
    }
    

    
    func setOption() {
        //Default
        viewOpt1.isHidden = true
        viewOpt2.isHidden = true
        viewOpt3.isHidden = true
        
        //Option 1
        if let opt1 = self.opt1 {
            viewOpt1.isHidden = false
            txtOption1.placeholder =  opt1
        } else {
            return
        }
        
        //Option 2
        if let opt2 = self.opt2 {
            viewOpt2.isHidden = false
            txtOption2.placeholder =  opt2
        } else {
            return
        }
        
        // Option 3
        if let opt3 = self.opt3 {
            viewOpt3.isHidden = false
            txtOption3.placeholder =  opt3
        } else {
            return
        }
        
    }
    
    func clearTextField() {
        txtName.text = nil
        txtBarcode.text = nil
        txtSKU.text = nil
        txtOption1.text = nil
        txtOption2.text = nil
        txtOption3.text = nil
        txtWeight.text = nil
        txtUnit.text = nil
        txtOnHand.text = nil
        txtRetailPrice.text = nil
        txtWholePrice.text = nil
        txtImportPrice.text = nil
        swTaxable.isOn = true
        swSellable.isOn = true
    }
    
    func fillupTextField() {
        txtName.text = variant.name
        txtBarcode.text = variant.barcode
        txtSKU.text = variant.sku
        txtOption1.text = variant.opt1
        txtOption2.text = variant.opt2
        txtOption3.text = variant.opt3
        txtWeight.text = "\(Int(variant.weight_value ?? 0))"
        txtUnit.text = variant.unit
        swTaxable.isOn = variant.taxable
        swSellable.isOn = variant.sellable
        
        if editMode == .edit {
            txtRetailPrice.text = "\(Int(variant.variant_retail_price ?? 0))"
            txtWholePrice.text = "\(Int(variant.variant_whole_price ?? 0))"
            txtImportPrice.text = "\(Int(variant.variant_import_price ?? 0))"
        } else {
            txtOnHand.text = "\(Int(variant.init_stock ?? 0))"
            txtCostPrice.text = "\(Int(variant.init_price ?? 0))"
            txtRetailPrice.text = "\(Int(variant.variant_retail_price ?? 0))"
            txtWholePrice.text = "\(Int(variant.variant_whole_price ?? 0))"
            txtImportPrice.text = "\(Int(variant.variant_import_price ?? 0))"
        }
        txtName.updateFloatingLabel()
        txtBarcode.updateFloatingLabel()
        txtUnit.updateFloatingLabel()
        txtSKU.updateFloatingLabel()
        txtWeight.updateFloatingLabel()
        txtImportPrice.updateFloatingLabel()
        txtRetailPrice.updateFloatingLabel()
        txtWholePrice.updateFloatingLabel()
        txtCostPrice.updateFloatingLabel()
        txtWeight.updateFloatingLabel()
        txtOption1.updateHeaderFloatingLabel(header: opt1)
        txtOption2.updateHeaderFloatingLabel(header: opt2)
        txtOption3.updateHeaderFloatingLabel(header: opt3)
        
    }
    
    func assignValue() {
        variant.name = txtName.text!
        if let barcode = txtBarcode.text {
            variant.barcode = barcode
        }
        if let sku = txtSKU.text {
            variant.sku = sku
        }
        if let weight = txtWeight.text {
            variant.weight_value = Double(weight)
        }
        variant.unit = txtUnit.text
        
        if let on_hand = txtOnHand.text {
            variant.init_stock = Double(on_hand)
        }
        variant.sellable = swSellable.isOn
        variant.taxable = swTaxable.isOn
        
        if let costPrice = txtCostPrice.text {
            variant.init_price = Double(costPrice)
        }
        var variant_prices = [Variant_Price]()
        
        if let retailPrice = txtRetailPrice.text {
            variant_prices.append(Variant_Price(id: 939262, value: retailPrice))
        }
        if let importPrice = txtImportPrice.text {
            variant_prices.append(Variant_Price(id: 939261, value: importPrice))
        }
        if let importPrice = txtWholePrice.text {
            variant_prices.append(Variant_Price(id: 939260, value: importPrice))
        }
        variant.variant_prices = variant_prices
 
        if editMode != .editOnInit {
            assignOptionValue()
        }
    }
    
    func assignOptionValue() {
        variant.opt1 = txtOption1.text
        variant.opt2 = txtOption2.text
        variant.opt3 = txtOption3.text
    }
    
    func check() -> Bool {
        guard let name = txtName.text else {
            return false
        }
        
        guard let opt1 = txtOption1.text else {
            return false
        }
        
        if name == "" || opt1 == "" {
            return false
        }
        
        if !viewOpt2.isHidden {
            if let opt2 = txtOption2.text {
                if opt2 == "" {
                    return false
                }
            } else {
                return false
            }
        }
        
        if !viewOpt3.isHidden {
            if let opt3 = txtOption3.text {
                if opt3 == "" {
                    return false
                }
            } else {
                return false
            }
        }
        return true
    }
    
    func addVariant() {
        let variantPost = VariantPost(variant: variant)
        NetworkService.shared.AddVariant(product_id: product_id, variant: variantPost, onSucess: { (variant) in
            self.showMessage(flag: true, title: "Thêm phiên bản thành công", mess: nil) {
                self.productDelegate?.UpdateProduct()
                self.navigationController?.popViewController(animated: true)
            }
        }) { (err) in
            self.showMessage(flag: false, title: "Có lỗi xảy ra", mess: err) { }
        }
    }
    
    func editVariant() {
        let variantPost = VariantPost(variant: self.variant)
        NetworkService.shared.editVariant(product_id: variant.product_id,variant_id: variant.id, variant: variantPost, onSucess: { (variant) in
            self.showMessage(flag: true, title: "Thành công", mess: nil) {
                self.variantDelegate?.editVariant(variant: variant)
                self.navigationController?.popViewController(animated: true)
            }
        }) { (err) in
            self.showMessage(flag: false, title: "Có lỗi xảy ra", mess: err) {}
        }
    }
    
    func editOnInitVariant() {
        assignValue()
        variantDelegate?.editVariant(variant: variant)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleSubmit(_ sender: Any) {
        submit(self)
    }
    
    @IBAction func submit(_ sender: Any) {
        if check() {
            assignValue()
            if editMode == .add {
                addVariant()
            } else if editMode == .edit {
                editVariant()
            } else {
                editOnInitVariant()
            }
        } else {
            self.showMessage(flag: false, title: "Hãy nhập đầy đủ tên phiên bản và các thuộc tính", mess: nil) {
                //do something
            }
        }

    }
}

protocol UpdateVariantDelegate {
    func editVariant(variant: Variant)
}
