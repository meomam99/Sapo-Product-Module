//
//  ProductAddViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/5/20.
//  Copyright © 2020 mac. All rights reserved.
//

struct Opt {
    init() {
        self.opt1 = nil
        self.opt2 = nil
        self.opt3 = nil
    }
    init(opt1: String?, opt2: String?, opt3: String?) {
        self.opt1 = opt1
        self.opt2 = opt2
        self.opt3 = opt3
    }
    var opt1: String?
    var opt2: String?
    var opt3: String?
}

import UIKit

class ProductAddViewController: UIViewController, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    var delegate: UpdateProductDelegate?
    
    var editMode: editMode = .add
    var product_id = 0
    var product: Product = Product()
    var variant: Variant = Variant()
    var variants = [Variant]()
    var categorySelected: Category = Category()
    
    @IBOutlet weak var view1: UIView! // name
    @IBOutlet weak var view2: UIView!  // barcode, sku, wieght
    @IBOutlet weak var view3: UIView! // price and stock
    @IBOutlet weak var view4: UIView! // more info
    @IBOutlet weak var view5: AddOptionView! // options
    @IBOutlet weak var view6: UIView! // status
    
    
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtSKU: CustomTextField!
    @IBOutlet weak var txtBarcode: CustomTextField!
    @IBOutlet weak var txtWeight: CustomTextField!
    @IBOutlet weak var txtUnit: CustomTextField!
    @IBOutlet weak var txtOnhand: CustomTextField!
    @IBOutlet weak var txtCostPrice: CustomTextField!
    @IBOutlet weak var txtRetailPrice: CustomTextField!
    @IBOutlet weak var txtWhloPrice: CustomTextField!
    @IBOutlet weak var txtImportPrice: CustomTextField!
    
    @IBOutlet weak var swTaxable: UISwitch!
    @IBOutlet weak var swSellable: UISwitch!
    @IBOutlet weak var swStatus: UISwitch!
    
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
 
    }

    func setupView() {
        if editMode == .edit {
            self.title = "Sửa sản phẩm"
            view2.isHidden = true
            view3.isHidden = true
            fillTextField()
            updateView()
        } else {
            btnRemove.isEnabled = false
            self.title = "Thêm sản phẩm"
            view6.isHidden = true
        }
        txtCostPrice.addDoneButton()
        txtImportPrice.addDoneButton()
        txtWeight.addDoneButton()
        txtWhloPrice.addDoneButton()
        txtRetailPrice.addDoneButton()
        txtOnhand.addDoneButton()
        txtName.delegate = self
        txtBarcode.delegate = self
        txtSKU.delegate = self
        txtWeight.delegate = self
        txtUnit.delegate = self
        txtOnhand.delegate = self
        txtCostPrice.delegate = self
        txtImportPrice.delegate = self
        txtRetailPrice.delegate = self
        txtWhloPrice.delegate = self
        view1.layer.setBorderSilver()
        view2.layer.setBorderSilver()
        view3.layer.setBorderSilver()
        view4.layer.setBorderSilver()
        view5.layer.setBorderSilver()
        view6.layer.setBorderSilver()
        btnOK.layer.cornerRadius = 8
    }
    
    func updateView() {
        btnRemove.isEnabled = true
        btnAdd.isEnabled = true
        if editMode == .edit {
            btnRemove.isEnabled = false
        }
        if view5.numberOfOptions() < 1 {
            btnRemove.isEnabled = false
            
        } else if view5.numberOfOptions() > 2 {
            btnAdd.isEnabled = false
        }
        
    }
    
    func reset() {
        variants = []
        variant = Variant()
        product = Product()
    }
    
    func check() -> Bool {
        if let name = txtName.text {
            if name == "" { return false }
        } else {
            return false
        }
        return true
    }
    
    func assignValue() {
        if editMode == .add {
            assignValueOnAdd()
        } else {
            assignValueOnEdit()
        }
    }
    
    func assignValueOnEdit() {
        
        product.name = txtName.text!
        product.category_id = categorySelected.id
        product.brand = lbBrand.text
        product.description = lbDescription.text
        if swStatus.isOn {
            product.status = "active"
        } else {
            product.status = "inactive"

        }
    }
    
    func assignValueOnAdd() {
        reset()
        if let weight = txtWeight.text {
            variant.weight_value = Double(weight)
        }
        variant.unit = txtUnit.text
        if let init_stock = txtOnhand.text {
            variant.init_stock = Double(init_stock)
        }
        variant.sellable = swSellable.isOn
        variant.taxable = swTaxable.isOn
        if let init_price = txtCostPrice.text {
            variant.init_price = Double(init_price)
        }
        
        var variant_prices = [Variant_Price]()
        if let retailPrice = txtRetailPrice.text {
            variant_prices.append(Variant_Price(id: 939262, value: retailPrice))
        }
        if let wholePrice = txtWhloPrice.text {
            variant_prices.append(Variant_Price(id: 939261, value: wholePrice))
        }
        if let importPrice = txtImportPrice.text {
            variant_prices.append(Variant_Price(id: 939260, value: importPrice))
        }
        variant.variant_prices = variant_prices
        
        let optionsCombination = view5.getOptionsCombination()
        
        if optionsCombination.count > 1 {
            for i in optionsCombination {
                variant.opt1 = i.opt1
                variant.opt2 = i.opt2
                variant.opt3 = i.opt3
                variant.name = txtName.text!  + " " + variant.getName()
                variants.append(variant)
            }
            product.variants = variants
        } else {
            variant.name = txtName.text!
            if let sku = txtSKU.text {
                variant.sku = sku
            }
            if let barcode = txtBarcode.text {
                variant.barcode = barcode
            }
            product.variants = [variant]
        }
        product.opt1 = view5.getOption1().name
        product.opt2 = view5.getOption2().name
        product.opt3 = view5.getOption3().name
        product.options = view5.getOption()
        product.name = txtName.text!
        product.category_id = categorySelected.id
        product.brand = lbBrand.text
        product.description = lbDescription.text
    }
    
    func AddOption(name: String, value: String, position: Int) {
        
        if editMode == .add {
            self.view5.addOption(name: name, value: value.toArray())
        } else {
            self.view5.addOption(name: name, value: [value.toArray()[0]])
            for i in 0..<product.variants.count {
                switch position {
                case 1:
                    product.variants[i].opt1 = value
                case 2:
                    product.variants[i].opt2 = value
                    
                case 3 :
                    product.variants[i].opt3 = value
                    
                default: break
                    // do something
                 }
             }
        }
        product.opt1 = view5.getOption1().name
        product.opt2 = view5.getOption2().name
        product.opt3 = view5.getOption3().name
        product.options = view5.getOption()
 
    }
    
    func showListVariant() {
        let controller: ProductAdd_ListVariantViewController = storyboard?.instantiateViewController(identifier: "productAdd_ListVariant") as! ProductAdd_ListVariantViewController
        controller.product = product
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showProductDetail() {
        let detailView: ProductDetailViewController = storyboard?.instantiateViewController(identifier: "productDetail") as! ProductDetailViewController
        detailView.product_id = self.product.id
        detailView.navigationController?.title = "Chi tiết sản phẩm"
            navigationController?.pushViewController(detailView, animated: true)
    }
    
    func clearTextField() {
        txtRetailPrice.text = nil
        txtUnit.text = nil
        txtWhloPrice.text = nil
        txtName.text = nil
        txtImportPrice.text = nil
        txtWeight.text = nil
        txtSKU.text = nil
        txtOnhand.text = nil
        txtBarcode.text = nil
        txtCostPrice.text = nil
        categorySelected = Category()
        lbBrand.text = nil
        lbDescription.text = nil
        view5.setupView()
    }
    
    func fillTextField() {
      
        txtName.text = product.name
        lbBrand.text = product.brand
        lbDescription.text = product.description
        lbCategory.text = product.category
        categorySelected = Category(id: product.category_id, name: product.category)
        if product.status == "active" {
            swStatus.isOn = true
        } else {
            swStatus.isOn = false
        }
        view5.setData(options: product.options)
        
        txtName.updateFloatingLabel()
     
    }
    
    @IBAction func addOption(_ sender: Any) {
        
        var mess = "Giá trị cách nhau bởi dấu phẩy"
        if editMode == .edit {
            mess = "Chỉ có thể thêm 1 giá trị cho thuộc tính"
        }
        
        let alert = UIAlertController(title: "Thêm thuộc tính", message: mess, preferredStyle: .alert)
        
        alert.addTextField { (txtName) in
                txtName.placeholder = "Tên thuộc tính"
            }
        alert.addTextField { (txtValue) in
                txtValue.placeholder = "Giá trị"
            }
        let btnCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let btnOK = UIAlertAction(title: "OK", style: .default) { (btn) in
            if let name = alert.textFields?[0].text, let value = alert.textFields?[1].text {
                if name != "" && value != "" {
                    self.AddOption(name: name, value: value, position: self.view5.numberOfOptions() + 1)
                    self.updateView()
                }
            }
   
        }
    
        alert.addAction(btnCancel)
        alert.addAction(btnOK)
        self.present(alert, animated: true)
        
        
        
    }
    
    @IBAction func removeOption(_ sender: Any) {
        if editMode == .add {
            view5.removeOption()
            updateView()
        }
    }
    
    
    func editProduct() {
        NetworkService.shared.editProduct(product_id: product_id, product: ProductPost(product: self.product), onSucess: { (product) in
            self.product = product
            self.clearTextField()
            self.showMessage(flag: true, title: "Cập nhật thành công", mess: nil) {
                self.delegate?.UpdateProduct()
                self.navigationController?.popViewController(animated: true)
            }
         }) { (err) in
            self.showMessage(flag: false, title: "Có lỗi xảy ra", mess: err) {}
         }
    }
    
    func addProduct() {
        NetworkService.shared.AddProduct(product: ProductPost(product: self.product), onSucess: { (product) in
            self.product = product
            self.clearTextField()
            self.showProductDetail()
        }) { (err) in
               self.showMessage(flag: false, title: "Có lỗi xảy ra", mess: err) {}
        }
    }
    @IBAction func submit(_ sender: Any) {
        if check() {
            assignValue()
            if editMode == .edit {
                editProduct()
            } else {
                if product.variants.count == 1 {
                    addProduct()
                } else {
                    showListVariant()
                }
            }
        } else {
            self.showMessage(flag: false, title: "Tên sản phẩm không được bỏ trống", mess: nil) {
                // do something
            }
        }
      
    }
    @IBAction func handleOK(_ sender: UIBarButtonItem) {
        submit(self)
    }
    
    @IBAction func selecetCategory(_ sender: UIButton) {
        let controller:ListCategoryViewController = storyboard?.instantiateViewController(identifier: "listCategoryView") as! ListCategoryViewController

        controller.categorySelected = categorySelected
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func selectBrand(_ sender: UIButton) {
        let controller:ListBrandViewController = storyboard?.instantiateViewController(identifier: "listBrandView") as! ListBrandViewController

        controller.brandSelected = lbBrand.text
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func editDescription(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(identifier: "textEdit") as! TextEditViewController
        controller.title = "Mô tả sản phẩm"
        controller.text = lbDescription.text
        controller.isEditMode = true
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated:  true)
    }
}

extension ProductAddViewController: SelectCategory {
    func setCategory(category: Category) {
        categorySelected = category
        lbCategory.text = categorySelected.name
    }
}

extension ProductAddViewController: SelectBrandDelegate {

    func setBrand(brand: String?) {
        lbBrand.text = brand
    }
}

extension ProductAddViewController: TextEditDelegate {
    func update(text: String) {
        lbDescription.text = text
    }
    
    
}
    


class ImageForProductCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        setupView()
    }
    func setupView() {
        self.img.layer.backgroundColor = UIColor.white.cgColor
        self.img.layer.cornerRadius = 8
    }
    func setData(image: UIImage) {
        self.img.layer.backgroundColor = UIColor.white.cgColor
        self.img.layer.cornerRadius = 8
        img.image = image
    }
    override func prepareForReuse() {
        img.image = nil
    }
    @IBAction func deleteImage(_ sender: Any) {
        
    }
}

