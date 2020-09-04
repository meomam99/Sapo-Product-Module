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
            img = "square.stack.3d.up"
            title = "Sản phẩm"
            lbTotal = " sản phẩm"
        } else {
            isProductMode = false
            img = "square.stack.3d.up.fill"
            title = "Quản lý kho"
            lbTotal = " phiên bản"
        }
    }
    var isProductMode: Bool
    var img: String = "dial"
    var title: String = "Sản phẩm"
    var lbTotal: String = " sản phẩm"
    
}

class ProductListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var products : [Product] = []
    var variants : [Variant] = []
    var categorySelected:Category = Category()
    var loadingData = false
    var isSearching = false
    var viewMode = ProductListViewMode(true)
    var total = 0
    var page = 1
    let limit = 20
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var btnSelectCategory: UIButton!
    @IBOutlet weak var btnSelectMode: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnCancelSearch: UIButton!
    
    @IBOutlet weak var txtSearch: LeftImageTextField!
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
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        cell.selectionStyle = .none
        if viewMode.isProductMode {
            let detailView: ProductDetailViewController = storyboard?.instantiateViewController(identifier: "productDetail") as! ProductDetailViewController
            detailView.product_id = products[indexPath.row].id
            detailView.delegate = self

            navigationController?.pushViewController(detailView, animated: true)
        } else {
   
            let variantDetailView: ProductVariantDetailViewController = storyboard?.instantiateViewController(identifier: "productVariantDetail") as! ProductVariantDetailViewController
            variantDetailView.delegate = self
            variantDetailView.variant = variants[indexPath.row]
            navigationController?.pushViewController(variantDetailView, animated: true)
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setData()
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnCancelSearch.isHidden = false
    }
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupView() {
        txtSearch.delegate = self
        self.title = "Danh sách sản phẩm"
        btnSelectMode.layer.cornerRadius = 20
        btnSetting.layer.cornerRadius = 20
        btnCancelSearch.layer.cornerRadius = 20
        btnCancelSearch.layer.borderColor = UIColor.systemGray.cgColor
        btnCancelSearch.layer.borderWidth = 1
        txtSearch.layer.cornerRadius = 20
        tbProductList.tableFooterView = UIView(frame: .zero)
        
    }
    
    func updateView() {

        btnSelectMode.setImage(UIImage(systemName: viewMode.img), for: .normal)
        lbTitle.text = viewMode.title
        btnSelectCategory.setTitle(categorySelected.name, for: .normal)

    }
    
    func updateTableView() {
        loadingData = false
        tbProductList.isHidden = false
        lbTotal.text = "\(total)" + viewMode.lbTotal
        tbProductList.dataSource = self
        tbProductList.delegate = self
        tbProductList.reloadData()
    }
    
    func setData() {
        page = 1
        total = 0
        tbProductList.isHidden = true
        NetworkService.shared.setPage(page: page)
        NetworkService.shared.setKeyword(key: txtSearch.text)
        updateData()
    }
    
    func updateData() {
        updateView()
        if viewMode.isProductMode {
            getProduct()
        } else {
            getVariant()
        }
    }
    
    func loadMore() {
        loadingData = true
        page += 1
        NetworkService.shared.setPage(page: page)
        updateData()
    }
    
    func getProduct() {
        NetworkService.shared.getProduct(category_id: categorySelected.id,onSucess: { (result) in
            if self.loadingData {
                self.products.append(contentsOf: result.products)
            } else {
                self.products = result.products
            }
            
            self.total = result.metadata.total
            self.updateTableView()
        }) { (error) in
            debugPrint(error)
        }
        
    }
    
    func getVariant() {
        NetworkService.shared.getVariant(category_id: categorySelected.id, onSucess: { (result) in
            if self.loadingData {
                 self.variants.append(contentsOf: result.variants)
             } else {
                 self.variants = result.variants
             }
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
        isSearching = true
    }
    
    @IBAction func cancelSearch(_ sender: Any) {
        view.endEditing(true)
        btnCancelSearch.isHidden = true
        txtSearch.text = nil
        if isSearching {
            setData()
            isSearching = false
        }
    }
    
}

extension ProductListViewController: SelectCategory {
    func setCategory(category: Category) {
        self.categorySelected = category
        self.setData()
    }
}
extension ProductListViewController: UpdateProductDelegate {
    func UpdateProduct() {
        self.setData()
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
        self.selectionStyle = .gray
        img.layer.cornerRadius = 5
        lbName.numberOfLines = 2
    }
    
    func setData(product: Product) {
        
        self.lbName.text = product.name
        img.image = UIImage(named: "noimage")
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
        img.image = nil
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
        self.selectionStyle = .gray
        img.layer.cornerRadius = 5
        lbName.numberOfLines = 2
    }
    
    func setData(variant: Variant) {
       
        self.lbName.text = variant.name
        img.image = UIImage(named: "noimage")
        if let images = variant.images {
            if !images.isEmpty {
                self.img.loadImageByURL(urlString: images[0].full_path)
            }
        }
        lbOnHand.text = variant.inventories[0].on_hand.toString()
        lbPrice.text = variant.getRetailPrice()
        lbSKU.text = "SKU: \(variant.sku)"

    }
    
    override func prepareForReuse() {
        img.image = nil
        lbName.text = nil
        lbSKU.text = nil
        lbPrice.text = nil
        lbOnHand.text = nil
    }
    
}
