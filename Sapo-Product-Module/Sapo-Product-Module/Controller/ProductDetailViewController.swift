//
//  ProductDetailViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/6/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        product.variants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productVariant", for: indexPath) as! ProductVariantCell
        cell.setData(productVariant: product.variants[indexPath.row])
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        cell.selectionStyle = .none
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showImage(images: product.images, index: indexPath.row, delegate: self)
    }

    var product: Product = Product()
    var product_id: Int = 0
    var imgPicker: ImagePicker!
    var delegate: UpdateProductDelegate?
    
    @IBOutlet weak var tbviewVariant: UITableView!
    @IBOutlet weak var collectionImage: UICollectionView!
    @IBOutlet weak var btnAdd: UIButton!

    @IBOutlet weak var tbviewHeighConstrain: NSLayoutConstraint!

    @IBOutlet weak var viewName: ProductNameView!
    @IBOutlet weak var viewInventoryInformation: ProductInventoryView!
    @IBOutlet weak var viewMoreInformation: ProductMoreInformationView!
    
    @IBOutlet weak var viewListVariant: UIView!
    
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbNumberOfVariants: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getProduct()
        navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
            return vc.isKind(of: ProductAddViewController.self) || vc.isKind(of: ProductAdd_ListVariantViewController.self)
           
        })
    }
    
    func getProduct() {
        NetworkService.shared.getProductById(product_id: product_id, onSucess: { (rs) in
            self.product = rs.product
            self.setData()
        }) { (err) in
            print(err)
        }
    }
    
    
    
    func setData() {
        
        // image collection view
        collectionImage.dataSource = self
        collectionImage.delegate = self
        collectionImage.reloadData()
        
        //name
        viewName.setData(product: self.product)
        
        //tbview
        viewListVariant.isHidden = false
        tbviewVariant.dataSource = self
        tbviewVariant.delegate = self
        tbviewVariant.reloadData()
        lbNumberOfVariants.text = "(\(product.variants.count))"
        tbviewHeighConstrain.constant = CGFloat(80*product.variants.count)
        tbviewVariant.isScrollEnabled = false
        
        // inventory
        viewInventoryInformation.isHidden = true
        
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
        
    }
    
    func setupView() {
        self.title = "Chi tiết sản phẩm"
        btnAdd.layer.setBorderSilver()

        viewListVariant.layer.setBorderSilver()
        viewStatus.layer.setBorderSilver()
    
        btnDelete.backgroundColor = .white
        btnDelete.layer.setBorderRed()

      }
    
    @IBAction func showDescription(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "textEdit") as! TextEditViewController
        controller.title = "Mô tả sản phẩm"
        controller.text = product.getDescription()
        controller.isEditMode = false
        self.navigationController?.pushViewController(controller, animated:  true)
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
        controller.product_id = product_id
        controller.editMode = .add
        controller.productDelegate = self
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func handleEditProduct(_ sender: Any) {

        let controller: ProductAddViewController = storyboard?.instantiateViewController(identifier: "productAdd") as! ProductAddViewController
        controller.editMode = .edit
        controller.product_id = self.product.id
        controller.product = self.product
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func deleteProduct(_ sender: Any) {
        self.showVerify(title: "Xóa sản phẩm", mess: nil) {
            NetworkService.shared.DeleteProduct(product_id: self.product.id, onSucess: {
                self.showMessage(flag: true, title: "Xóa sản phẩm thành công",mess: nil, onCompletion: {
                    self.delegate?.UpdateProduct()
                    self.navigationController?.popViewController(animated: true)
                })
                
            }) { (err) in
                self.showMessage(flag: false, title: "Có lỗi xảy ra, thử lại sau ", mess: nil) {
                    // do something
                }
            }
        }
        
    }
    


}
extension ProductDetailViewController: UpdateProductDelegate  {
    func UpdateProduct() {
        self.getProduct()
        self.delegate?.UpdateProduct()
    }
}

extension ProductDetailViewController: UpdateImageDelegate {
    func UpdateImage(image: Image) {
        NetworkService.shared.DeleteImageFromProduct(product_id: product.id, image_id: image.id, onSucess: {
            self.getProduct()
        }) { (err) in
            // do something
        }
    }
}
extension ProductDetailViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let img = image {

            let imgData: Data = img.jpegData(compressionQuality: 0.1)!
            let strbase64 = imgData.base64EncodedString(options: .init())
            let img = ImageForProduct(strbase64: strbase64)
            NetworkService.shared.AddImageToProduct(product_id: product.id, imageForProduct: img, onSucess: {
                self.getProduct()
                self.delegate?.UpdateProduct()
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
    
    override func prepareForReuse() {
        imgProduct.image = nil
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
        self.selectionStyle = .gray
        self.img.layer.backgroundColor = UIColor.white.cgColor
        self.img.layer.cornerRadius = 8
    }
    
    func setData(productVariant: Variant) {
        lbSKU.text = "SKU: \(productVariant.sku)"
        lbPrice.text = productVariant.getRetailPrice()
        lbName.text = productVariant.getName()
        lbStock.text = "Tồn kho: \(Int(productVariant.inventories[0].on_hand))"
        img.image = UIImage(named: "noimage")
        if let images = productVariant.images {
            if !images.isEmpty {
                self.img.loadImageByURL(urlString: images[0].full_path)
            }
        }
    }
    
    override func prepareForReuse() {
        img.image = nil
    }
    
}
