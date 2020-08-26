//
//  ProductDetailViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/6/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        product.variants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productVariant", for: indexPath) as! ProductVariantCell
        cell.setData(productVariant: product.variants[indexPath.row])
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let variantDetailView: ProductVariantDetailViewController = storyboard?.instantiateViewController(identifier: "productVariantDetail") as! ProductVariantDetailViewController
        variantDetailView.variant = product.variants[indexPath.row]
        variantDetailView.delegate = self
        navigationController?.pushViewController(variantDetailView, animated: true)
        navigationController?.title = "Chi tiết phiên bản"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        product.images.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath) as! ProductImageCell
        cell.setData(img_path: product.images[indexPath.row].full_path)
        return cell
    }
    

    var product: Product = Product()
    var imgPicker: ImagePicker!

    @IBOutlet weak var tbviewVariant: UITableView!
    @IBOutlet weak var collectionImage: UICollectionView!
    @IBOutlet weak var btnAdd: UIButton!


    @IBOutlet weak var viewName: ProductNameView!
    @IBOutlet weak var viewInventoryInformation: ProductInventoryView!
    @IBOutlet weak var viewMoreInformation: ProductMoreInformationView!
    
    @IBOutlet weak var viewListVariant: UIView!
    
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lbStatus: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setData()
    }
    
    func getProduct() {
        NetworkService.shared.setProductId(product_id: product.id)
        NetworkService.shared.getProductById(onSucess: { (rs) in
            self.product = rs.product
            self.setData()
        }) { (err) in
            print(err)
        }
    }
    
    func setData() {
        
        //tbview
        if product.variants.count == 1 {
            viewListVariant.isHidden = true
            viewInventoryInformation.setData(variant: product.variants[0])
        } else {
            viewInventoryInformation.isHidden = true
            tbviewVariant.dataSource = self
            tbviewVariant.delegate = self
        }
        
        //more information
        viewMoreInformation.setData(product: product)
        
        //status
        if product.status == "active" {
            imgStatus.tintColor = .systemGreen
            lbStatus.text = "Đang giao dịch"
        } else {
            imgStatus.tintColor = .systemOrange
            lbStatus.text = "Ngừng giao dịch"
        }
        
        //name
        viewName.setData(product: self.product)
        
        
        collectionImage.dataSource = self

    }
    
    func setupView() {

        
        btnAdd.backgroundColor = .white
        btnAdd.layer.setBorderSilver()

        viewListVariant.layer.setBorderSilver()
        viewStatus.layer.setBorderSilver()
    
        btnDelete.backgroundColor = .white
        btnDelete.layer.setBorderRed()

      }
    
    @IBAction func showDescription(_ sender: Any) {
        let descriptionView: ProductDescriptionViewController = storyboard?.instantiateViewController(identifier: "description") as! ProductDescriptionViewController
        descriptionView.desc = self.product.description
        navigationController?.pushViewController(descriptionView, animated: true)
    }
    

    @IBAction func addImage(_ sender: UIButton) {
        self.imgPicker = ImagePicker(presentationController: self, delegate: self)
        self.imgPicker.present(from: sender)
    }
    
    
    @IBAction func addVariant(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "addVariant") as! AddVariantViewController
        controller.opt1 = product.opt1
        controller.opt2 = product.opt2
        controller.opt3 = product.opt3
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func deleteProduct(_ sender: Any) {
        let alert = UIAlertController(title: "Xóa sản phẩm: ", message: product.name, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "OK", style: .default) { (btn) in
            NetworkService.shared.setProductId(product_id: self.product.id)
 
            NetworkService.shared.DeleteProduct(onSucess: {
                self.showMessage(flag: true, mess: "Xóa sản phẩm thành công", onCompletion: {
                    self.navigationController?.popViewController(animated: true)
                })
                
            }) { (err) in
                self.showMessage(flag: false, mess: "Có lỗi xảy ra, thử lại sau ") {
                    // do nothing
                }
            }
        }
        let btnCancel = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
        alert.addAction(btnCancel)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    


}
extension ProductDetailViewController: UpdateProduct  {
    func UpdateVariant() {
        self.getProduct()
    }
    
    func DeleteVariant() {
        self.getProduct()
    }

}
extension ProductDetailViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let img = image {

            let imgData: Data = img.jpegData(compressionQuality: 0.1)!
            let strbase64 = imgData.base64EncodedString(options: .init())
            NetworkService.shared.setProductId(product_id: product.id)
            NetworkService.shared.SetImageForProduct(image: strbase64)
            NetworkService.shared.AddImageToProduct(onSucess: {
                self.getProduct()
            }) { (err) in
                print(err)
            }
            
        }
        
    }
}



class ProductImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        imgProduct.layer.cornerRadius = 5
        imgProduct.backgroundColor = .white
        self.imgProduct.image = UIImage(named: "noimage")
    }
    
    func setData(img_path: String) {
        self.imgProduct.loadImageByURL(urlString: img_path)
    }
    
}

class ProductVariantCell: UITableViewCell {
    
    @IBOutlet weak var lbStock: UILabel!
    @IBOutlet weak var lbSKU: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        setupView()
    }
    func setupView() {
        self.img.image = UIImage(named: "noimage")
        self.img.layer.backgroundColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        self.img.layer.cornerRadius = 8
    }
    
    func setData(productVariant: Variant) {
        lbSKU.text = "SKU: \(productVariant.sku)"
        lbPrice.text = productVariant.variant_retail_price.toString()
        lbName.text = productVariant.getName()
        lbStock.text = "Tồn kho: \(productVariant.getInStock())"
        if let images = productVariant.images {
            if !images.isEmpty {
                self.img.loadImageByURL(urlString: images[0].full_path)
            }
        }
    }
    
}
