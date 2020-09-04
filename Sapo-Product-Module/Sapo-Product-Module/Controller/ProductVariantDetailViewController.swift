//
//  ProductVariantDetailViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/6/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

let ABOUT_IMPORT_PRICE = "Giá nhập là đơn giá nhập hàng của sản phẩm, chưa bao gồm chiết khấu, thuế và các chi phí nhập hàng khác."

class ProductVariantDetailViewController: UIViewController {
   
    var variant: Variant = Variant()
  //  var options = [Option]()
    var option1: String?
    var option2: String?
    var option3: String?
    var delegate: UpdateProductDelegate?
    
    @IBOutlet weak var viewName: ProductNameView!
    @IBOutlet weak var viewSellable: ProductSellableView!
    @IBOutlet weak var viewInventory: ProductInventoryView!
    @IBOutlet weak var imgVariant: UIImageView!
   
    @IBOutlet weak var viewBtnAddImage: UIView!
    
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var btnDeleteVariant: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getVariant()
        getOption()
    }
    
    func getVariant() {
        NetworkService.shared.getVariantById(product_id: variant.product_id, variant_id: variant.id, onSucess: {(rs) in
            self.variant = rs.variant
            self.getOption()
            self.setData()
        }) { (err) in
        }
    }
    
    func getOption() {
        NetworkService.shared.getProductById(product_id: variant.product_id,  onSucess: {(rs) in
            self.option1 = rs.product.opt1
            self.option2 = rs.product.opt2
            self.option3 = rs.product.opt3
          }) { (err) in
          }
    }
    
    @IBAction func handleEditVariant(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "addVariant") as! AddVariantViewController
        controller.opt1 = option1
        controller.opt2 = option2
        controller.opt3 = option3
        controller.editMode = .edit
        controller.variantDelegate = self
        controller.variant = variant
        controller.product_id = variant.id
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    func setupView() {
        self.title = "Chi tiết phiên bản"

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imgTapped(tapGestureRecognizer: )))
        imgVariant.isUserInteractionEnabled = true
        imgVariant.addGestureRecognizer(tapGesture)
        btnAddImage.layer.setBorderSilver()
        btnDeleteVariant.layer.setBorderRed()
        imgVariant.layer.setBorderSilver()
        imgVariant.backgroundColor = .white
  
    }
    
    @objc func imgTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Tùy chọn", message: nil, preferredStyle: .actionSheet)
        let btnView = UIAlertAction(title: "Xem ảnh", style: .default) { (btn) in
            self.showImage(images: self.variant.images!, index: 0, delegate: self)
            
        }
        let btnChange = UIAlertAction(title: "Đổi ảnh", style: .default) { (btn) in
            self.setImageForVariant(self)
        }
        let btnDelete = UIAlertAction(title: "Xóa ảnh", style: .destructive) { (btn) in
            self.updateImageForVariant(image_id: 0)
        }
        
        let btnCancel = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
        alert.addAction(btnView)
        alert.addAction(btnChange)
        alert.addAction(btnDelete)
        alert.addAction(btnCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setImageView() {
        imgVariant.isHidden = true
        viewSellable.layer.setBorderSilver()
        viewBtnAddImage.isHidden = false
        guard let images = variant.images else {
            return
        }
        if !images.isEmpty {
            imgVariant.isHidden = false
            viewBtnAddImage.isHidden = true
            imgVariant.loadImageByURL(urlString: images[0].full_path)
        
        }
    }

    func setData() {
        setImageView()
        viewName.setData(variant: variant)
        viewName.showOption(variant: variant, option1: option1, option2: option2, option3: option3)
        viewInventory.setData(variant: variant)
        viewSellable.setData(sellable: variant.sellable)
    }
    
    func updateImageForVariant(image_id: Int) {
        let imgForVariant = ImageForVariant(image_id: image_id)
        NetworkService.shared.SetImageForVariant(product_id: variant.product_id,variant_id: variant.id, image: imgForVariant,  onSucess: { (rs) in
            self.variant = rs.variant
            self.setImageView()
            self.delegate?.UpdateProduct()
        }) { (err) in
            print(err)
        }
    }
    
    
    @IBAction func showInventoryInfo(_ sender: UIButton) {
        let on_hand = variant.inventories[0].on_hand.toString()
        let avalable = variant.inventories[0].available.toString()
        let incoming = variant.inventories[0].incoming.toString()
        let onway = variant.inventories[0].onway.toString()
        let info = "Tồn kho: \(on_hand) \nCó thể bán: \(avalable) \nĐang về: \(onway) \nĐang xử lí: \(incoming)"
        
        self.showMessage(flag: true, title: "Thông tin kho", mess: info) {
            // do something
        }
    }
    
    @IBAction func showPriceInfo(_ sender: Any) {
        
        self.showMessage(flag: true,title: "Giá nhập", mess: ABOUT_IMPORT_PRICE, onCompletion: {
            //do something
        })
    }
    
    @IBAction func setImageForVariant(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(identifier: "setImageForVariant") as! SetImageForVariantViewController
        controller.product_id = variant.product_id

        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    @IBAction func deleteVariant(_ sender: Any) {
        self.showVerify(title: "Xóa phiên bản", mess: nil) {
            NetworkService.shared.DeleteVariant(product_id: self.variant.product_id, variant_id: self.variant.id,  onSucess: {
                self.showMessage(flag: true,title:"Xóa phiên bản thành công", mess: nil, onCompletion: {
                    self.delegate?.UpdateProduct()
                    self.navigationController?.popViewController(animated: true)
                })
                
            }) { (err) in
                self.showMessage(flag: false,title: err, mess: nil, onCompletion: {
                    // do something
                })
            }
        }
   
    }

}

extension ProductVariantDetailViewController: SetImageForVariantDelegate {
    func setImage(image: Image) {
        updateImageForVariant(image_id: image.id)
    }
}

extension ProductVariantDetailViewController: UpdateImageDelegate {
    func UpdateImage(image: Image) {
        updateImageForVariant(image_id: 0)
    }
}

extension ProductVariantDetailViewController: UpdateVariantDelegate {
    func editVariant(variant: Variant) {
        self.variant = variant
        getOption()
        setData()
        self.delegate?.UpdateProduct()
    }
    
   
    
}

protocol UpdateProductDelegate {
    func UpdateProduct()
}
