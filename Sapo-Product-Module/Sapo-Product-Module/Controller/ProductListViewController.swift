//
//  ProductListViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/5/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

struct ProductListViewMode {
    
    init(_ mode: Bool) {
        if mode {
            isProductMode = true
            img = "dial"
            title = "Sản phẩm"
            lbTotal = " sản phẩm"
        } else {
            isProductMode = false
            img = "dial.fill"
            title = "Quản lý kho"
            lbTotal = " phiên bản"
        }
    }
    var isProductMode: Bool
    var img: String = "dial"
    var title: String = "Sản phẩm"
    var lbTotal: String = " sản phẩm"
    
}

class ProductListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var products : [Product] = []
    var variants : [Variant] = []
    var categorySelected:Category = Category()
    var loadingData = false
    var viewMode = ProductListViewMode(true)
    var isSearching = false
    var total = 0
    var page = 1
    var limit = 20
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var btnSelectCategory: UIButton!
    @IBOutlet weak var btnSelectMode: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnCancelSearch: UIButton!
    
    @IBOutlet weak var txtSearch: UITextField!

    @IBOutlet weak var tbProductList: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewMode.isProductMode {
            return products.count
        } else {
            return variants.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(viewMode.isProductMode) {
           let cell:ProductListCell = tableView.dequeueReusableCell(withIdentifier: "product", for: indexPath) as! ProductListCell
            cell.setData(product: products[indexPath.row])
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "variant", for: indexPath) as! VariantListCell
            cell.setData(variant: variants[indexPath.row])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 >= tableView.numberOfRows(inSection: 0) {
            if !loadingData && indexPath.row + 1 < self.total {
                loadMore()
            }
        }
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if viewMode.isProductMode {
          
                let detailView: ProductDetailViewController = storyboard?.instantiateViewController(identifier: "productDetail") as! ProductDetailViewController
                detailView.product = products[indexPath.row]
                detailView.navigationController?.title = "Chi tiết sản phẩm"
                navigationController?.pushViewController(detailView, animated: true)
                return

        } else {
   
            let variantDetailView: ProductVariantDetailViewController = storyboard?.instantiateViewController(identifier: "productVariantDetail") as! ProductVariantDetailViewController
            variantDetailView.delegate = self
            variantDetailView.variant = variants[indexPath.row]
            navigationController?.pushViewController(variantDetailView, animated: true)
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setData()
        navigationController?.navigationItem.backBarButtonItem?.image = UIImage(systemName: "arrow.left")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupView() {
        tbProductList.tableFooterView = UIView(frame: .zero)
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.title = ""
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.image = UIImage(systemName: "lessthan")
        self.navigationController?.navigationBar.topItem?.title = "Sản phẩm"
        txtSearch.layer.cornerRadius = 15
    }
    
    func updateView() {

        btnSelectMode.setImage(UIImage(systemName: viewMode.img), for: .normal)
        lbTitle.text = viewMode.title

        btnSelectCategory.titleLabel?.text = categorySelected.name
        
    }
    
    func updateTableView() {
        loadingData = false
        lbTotal.text = "\(total)" + viewMode.lbTotal
        tbProductList.dataSource = self
        tbProductList.delegate = self
        tbProductList.reloadData()
    }
    
    func setData() {
        variants = []
        products = []
        page = 1
        NetworkService.shared.setPage(page: page)
        limit = 20
        updateData()
    }
    
    func updateData() {
        NetworkService.shared.setCategory(category: categorySelected)
        NetworkService.shared.setKeyword(key: txtSearch.text)
        updateView()
        if viewMode.isProductMode {
            getProduct()
        } else {
            getVariant()
        }
        
    }
    
    func loadMore() {
        self.loadingData = true
        page += 1
        NetworkService.shared.setPage(page: page)
        updateData()
    }
    
    func getProduct() {
        variants = []
        NetworkService.shared.getProduct(onSucess: { (result) in
            self.products.append(contentsOf: result.products)
            self.total = result.metadata.total
            self.updateTableView()
        }) { (error) in
            debugPrint(error)
        }

    }
    
    func getVariant() {
        products = []
        NetworkService.shared.getVariant(onSucess: { (result) in
            self.variants.append(contentsOf: result.variants)
            self.total = result.metadata.total
            self.updateTableView()
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
    
    @IBAction func selectMode(_ sender: Any) {
        let flag = !viewMode.isProductMode
            viewMode = ProductListViewMode(flag)
            setData()
    }
    
    @IBAction func setting(_ sender: Any) {
        
    }
    
    @IBAction func search(_ sender: UITextField) {
        btnCancelSearch.isHidden = false
        isSearching = true
        updateData()
    }
    
  
    @IBAction func editingBegin(_ sender: UITextField) {
        btnCancelSearch.isHidden = false
    }
    
    @IBAction func cancelSearch(_ sender: Any) {
        view.endEditing(true)
        btnCancelSearch.isHidden = true
        isSearching = false
        txtSearch.text = nil
        updateData()
    }
    
}


extension ProductListViewController: SelectCategory {
    func setCategory(category: Category) {
        self.categorySelected = category
        self.setData()
    }
}
extension ProductListViewController: UpdateProduct {
    func DeleteVariant() {
        self.setData()
    }
    
    func UpdateVariant() {
        
    }
    
    
}


// cell for tableview in Product mode
class ProductListCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbNumberOfVariants: UILabel!
    @IBOutlet weak var lbQuantity: UILabel!
        
    override func awakeFromNib() {
        setupView()

    }
    
    func setupView() {
        img.image = UIImage(named: "noimage")
        img.layer.cornerRadius = 5
        lbName.numberOfLines = 2
    }
    
    func setData(product: Product) {
        self.lbName.text = product.name
        if !product.images.isEmpty {
           self.img.loadImageByURL(urlString: product.images[0].full_path)
        }
        lbNumberOfVariants.text = "\(product.variants.count)"
        lbQuantity.text = "\(product.getQuantity())"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lbName.text = nil
        lbNumberOfVariants.text = nil
        lbQuantity.text = nil
        img.image = UIImage(named: "noimage")
    }
 
    
}

// cell for table view in Variant mode
class VariantListCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbSKU: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbOnHand: UILabel!
        
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        img.layer.cornerRadius = 5
        lbName.numberOfLines = 2
        img.image = UIImage(named: "noimage")
    }
    
    func setData(variant: Variant) {
        self.lbName.text = variant.name
        if let images = variant.images {
            if !images.isEmpty {
                self.img.loadImageByURL(urlString: images[0].full_path)
            }
        }
        lbOnHand.text = "\(Int(variant.inventories[0].on_hand))"
        lbPrice.text = "\(Int(variant.variant_retail_price))"
        lbSKU.text = "SKU: \(variant.sku)"

    }
    
    override func prepareForReuse() {
        img.image = UIImage(named: "noimage")
        lbName.text = nil
        
    }
    
}
