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
        cell.productVariant = product.variants[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       let cell = cell as! ProductVariantCell
        cell.setupView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let variantDetailView: ProductVariantDetailViewController = storyboard?.instantiateViewController(identifier: "productVariantDetail") as! ProductVariantDetailViewController
               variantDetailView.product = product
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
        cell.img_path = product.images[indexPath.row].full_path
        cell.setupView()
        return cell
    }
    

    var product: Product = Product()

    @IBOutlet weak var moreInfo: UIView!
    @IBOutlet weak var tbviewVariant: UITableView!
    @IBOutlet weak var collectionImage: UICollectionView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewMoreInformation: UIView!
    @IBOutlet weak var viewListVariant: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setData()
        
    }
    
    func setData() {
        
        //name
        lbName.text = product.name
        
        //more information
        lbCategory.text = product.getCategory()
        lbBrand.text = product.getBrand()
        lbDescription.text = product.getDescription()
        
        collectionImage.dataSource = self
        tbviewVariant.dataSource = self
        tbviewVariant.delegate = self
        
    }
    
    @IBAction func viewMore(_ sender: Any) {
        var img = "chevron.up"
        moreInfo.isHidden = !moreInfo.isHidden
        let sender = sender as! UIButton
        if moreInfo.isHidden {
            img = "chevron.down"
        }
        sender.setBackgroundImage(UIImage(systemName: img), for: .normal)
        
    }
    
      func setupView() {
    
        btnAdd.backgroundColor = .white
        btnAdd.layer.cornerRadius = 8
        btnAdd.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        btnAdd.layer.borderWidth = 1
        viewName.layer.cornerRadius = 8
        viewName.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        viewName.layer.borderWidth = 1
        viewListVariant.layer.cornerRadius = 8
        viewListVariant.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        viewListVariant.layer.borderWidth = 1
        viewStatus.layer.cornerRadius = 8
        viewStatus.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        viewStatus.layer.borderWidth = 1
        viewMoreInformation.layer.cornerRadius = 8
        viewMoreInformation.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        viewMoreInformation.layer.borderWidth = 1
        viewMoreInformation.backgroundColor = .white
        btnDelete.layer.cornerRadius = 8
        btnDelete.layer.borderColor = .init(srgbRed: 1, green: 0, blue: 0, alpha: 1)
        btnDelete.layer.borderWidth = 1

      

      }
    
    @IBAction func showDescription(_ sender: Any) {
    }
    
    @IBAction func addImage(_ sender: Any) {
    }
    
    @IBAction func addVariant(_ sender: Any) {
    }
    
    @IBAction func deleteProduct(_ sender: Any) {
    }
    



}



class ProductImageCell: UICollectionViewCell {
    
    var img_path = ""
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    override func awakeFromNib() {
        self.imgProduct.image = UIImage(named: "noimage")
    }
    
    func setupView() {
        imgProduct.layer.cornerRadius = 5
        imgProduct.backgroundColor = .white
        self.imgProduct.loadImageByURL(urlString: img_path)
    }
    
}

class ProductVariantCell: UITableViewCell {
    
    var productVariant = Variant()
    
    @IBOutlet weak var lbStock: UILabel!
    @IBOutlet weak var lbSKU: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        self.img.image = UIImage(named: "noimage")
    }
    func setupView() {
        lbSKU.text = "SKU: \(productVariant.sku)"
        lbPrice.text = "\(productVariant.variant_retail_price)"
        lbName.text = productVariant.getName()
        lbStock.text = "Tồn kho: \(productVariant.getInStock())"
        if(productVariant.images != nil) {
            img.loadImageByURL(urlString: (productVariant.images?[0].full_path)!)
        }
    }
    
}
