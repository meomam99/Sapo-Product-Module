//
//  ProductVariantDetailViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/6/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ProductVariantDetailViewController: UIViewController,  UICollectionViewDataSource {

    @IBOutlet weak var collectionImageProduct: UICollectionView!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = UIColor(displayP3Red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        collectionImageProduct.backgroundColor = UIColor(displayP3Red: 237/255, green: 237/255, blue: 237/255, alpha: 1)

        collectionImageProduct.dataSource = self
    }

    @IBAction func addProduct(_ sender: Any) {
    }
    

}
