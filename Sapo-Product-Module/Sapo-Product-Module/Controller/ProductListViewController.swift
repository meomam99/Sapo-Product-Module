//
//  ProductListViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/5/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var products : [Product] = []
    var categorySelected:Category = Category()
    var loadingData = false
    var total = 0
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var btnSelectCategory: UIButton!
    @IBOutlet weak var tbProductList: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product", for: indexPath) as! ProductListCell
        cell.product = products[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! ProductListCell
        cell.setupNode()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if products[indexPath.row].variants.count == 1 {
            let variantDetailView: ProductVariantDetailViewController = storyboard?.instantiateViewController(identifier: "productVariantDetail") as! ProductVariantDetailViewController
            variantDetailView.product = products[indexPath.row]
            navigationController?.pushViewController(variantDetailView, animated: true)
        } else {
            let detailView: ProductDetailViewController = storyboard?.instantiateViewController(identifier: "productDetail") as! ProductDetailViewController
            detailView.product = products[indexPath.row]
            
            navigationController?.pushViewController(detailView, animated: true)
          
        }
        navigationController?.title = "Chi tiết sản phẩm"

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getProduct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    func setupView() {
        
    }
    
    func updateView() {
        tbProductList.dataSource = self
        tbProductList.delegate = self
        tbProductList.reloadData()
        lbTotal.text = "\(total) sản phẩm"
        btnSelectCategory.titleLabel?.text = categorySelected.name
    }
    
    func getProduct() {
        NetworkService.shared.setCategory(category: categorySelected)
        NetworkService.shared.getProduct(onSucess: { (result) in
            self.products = result.products
            self.total = result.metadata.total
            self.updateView()
        }) { (error) in
            debugPrint(error)
        }
    }
    
    
    @IBAction func selectCategory(_ sender: Any) {

        
        let controller:ListCategoryViewController = storyboard?.instantiateViewController(identifier: "listCategoryView") as! ListCategoryViewController
        
        controller.categorySelected = categorySelected
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)


        
    }
    
}

extension ProductListViewController: SelectCategory {
    func setCategory(category: Category) {
        self.dismiss(animated: true) {
            self.categorySelected = category
            self.getProduct()
        }
    }
    
  
}

class ProductListCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbNumberOfVariants: UILabel!
    @IBOutlet weak var lbQuantity: UILabel!
    
    var product: Product = Product()
    
    override func awakeFromNib() {
        setupView()
        img.image = UIImage(named: "noimage")
    }
    
    func setupNode() {
        setupView()
        self.lbName.text = product.name
        if !product.images.isEmpty {
           self.img.loadImageByURL(urlString: product.images[0].full_path)
        } else {
            self.img.image = UIImage(named: "noimage")
        }
        lbNumberOfVariants.text = "\(product.variants.count)"
        lbQuantity.text = "\(product.getQuantity())"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lbName.text = nil
        lbNumberOfVariants.text = nil
        lbQuantity.text = nil
        img.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
}
extension ProductListCell {
    func setupView() {
        img.layer.cornerRadius = 5
        lbName.numberOfLines = 2
    }
}
