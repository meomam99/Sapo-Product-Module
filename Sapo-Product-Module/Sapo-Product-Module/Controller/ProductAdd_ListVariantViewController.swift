//
//  ProductAdd_ListVariantViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 9/2/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ProductAdd_ListVariantViewController: UIViewController {

    @IBOutlet weak var tbListVariant: UITableView!
    
    var index = 0
    var product = Product()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        tbListVariant.tableFooterView = UIView(frame: .zero)
        tbListVariant.dataSource = self
        tbListVariant.delegate = self
    }
    
    @IBAction func handleSave(_ sender: Any) {
        addProduct()
    }
    
    func addProduct() {
        NetworkService.shared.AddProduct(product: ProductPost(product: self.product), onSucess: { (p) in
            self.product = p
            self.showProductDetail()
        }) { (err) in
            self.showMessage(flag: false, title: "Có lỗi xảy ra", mess: err, onCompletion: {
              // do something
            })
        }
        
    }
    func showProductDetail() {
        let detailView: ProductDetailViewController = storyboard?.instantiateViewController(identifier: "productDetail") as! ProductDetailViewController
        detailView.product_id = self.product.id
        detailView.navigationController?.title = "Chi tiết sản phẩm"
            navigationController?.pushViewController(detailView, animated: true)
        
    }
}

extension ProductAdd_ListVariantViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.variants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productVariant", for: indexPath) as! VariantOnAddProductCell
        cell.setData(productVariant: product.variants[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "addVariant") as! AddVariantViewController
        controller.editMode = .editOnInit
        index = indexPath.row
        controller.variantDelegate = self
        controller.variant = product.variants[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ProductAdd_ListVariantViewController: UpdateVariantDelegate {
    func editVariant(variant: Variant) {
        product.variants[index] = variant
        tbListVariant.dataSource = self
        tbListVariant.reloadData()
    }
}

class VariantOnAddProductCell: UITableViewCell {
    @IBOutlet weak var lbStock: UILabel!
    @IBOutlet weak var lbSKU: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        setupView()
    }
    func setupView() {
        lbName.numberOfLines = 3
    }
    
    func setData(productVariant: Variant) {
        lbSKU.text = "SKU: \(productVariant.sku)"
        lbPrice.text = "Giá vốn: " + (productVariant.init_price ?? 0).toString()
        lbName.text = productVariant.name
        lbStock.text = "Tồn kho: " + (productVariant.init_stock ?? 0).toString()
     
    }
    
}
