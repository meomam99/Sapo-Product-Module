//
//  ProductVariantDetailViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/6/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ProductVariantDetailViewController: UIViewController {
   
    var variant: Variant = Variant()
    var delegate: UpdateProduct?
    
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
        setData()
    }
    
    func setupView() {
        navigationController?.title = "Chi tiết phiên bản"
        navigationItem.backBarButtonItem?.title = "Back"
        btnAddImage.layer.setBorderSilver()
        btnDeleteVariant.layer.setBorderRed()
        imgVariant.layer.setBorderSilver()
        imgVariant.backgroundColor = .white
  
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
        viewName.showOption(variant: variant)
        viewInventory.setData(variant: variant)
        viewSellable.setData(sellable: variant.sellable)
    }
    
    
    @IBAction func setImageForVariant(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(identifier: "setImageForVariant") as! SetImageForVariantViewController
        controller.product_id = variant.product_id
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func deleteVariant(_ sender: Any) {
        
        let alert = UIAlertController(title: "Xóa phiên bản: ", message: variant.name, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "OK", style: .default) { (btn) in
            NetworkService.shared.setProductId(product_id: self.variant.product_id)
            NetworkService.shared.setVariantId(variant_id: self.variant.id)
            NetworkService.shared.DeleteVariant(onSucess: {
                self.showMessage(flag: true, mess: "Xóa phiên bản thành công", onCompletion: {
                    self.delegate?.DeleteVariant()
                    self.navigationController?.popViewController(animated: true)
                })
                
            }) { (err) in
                self.showMessage(flag: false, mess: "Có lỗi xảy ra, thử lại sau", onCompletion: {
                    // do nothing
                })
            }
        }
        let btnCancel = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
        alert.addAction(btnCancel)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
        
    }

}

extension ProductVariantDetailViewController: SetImageForVariant {
    func setImage(image: Image) {
        NetworkService.shared.setVariantId(variant_id: variant.id)
        NetworkService.shared.setProductId(product_id: variant.product_id)
        NetworkService.shared.SetImageForVariant(image: image)
        NetworkService.shared.SetImageForVariant(onSucess: { (rs) in
            self.variant = rs.variant
            self.setImageView()
            self.delegate?.UpdateVariant()
        }) { (err) in
            print(err)
        }
        
    }
}

protocol UpdateProduct {
    func DeleteVariant()
    func UpdateVariant()
}
