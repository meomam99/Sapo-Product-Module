//
//  SetImageForVariantViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/24/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class SetImageForVariantViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath) as! ProductImageCell
        cell.setData(img_path: images[indexPath.row].full_path)
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.setImage(image: images[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    

    @IBOutlet weak var collectionImage: UICollectionView!
    
    var product_id: Int = 0
    var images = [Image]()
    
    var delegate: SetImageForVariant?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        collectionImage.delegate = self
        loadImages()
    }
    
    func setupView() {
        view.backgroundColor = .systemGray6
    }
    
    func updateView() {
        collectionImage.dataSource = self
      
    }
    
    func loadImages() {
        NetworkService.shared.setProductId(product_id: product_id)
        NetworkService.shared.getProductById(onSucess: { (rs) in
            self.images = rs.product.images
            self.updateView()
        }) { (err) in
            debugPrint(err)
        }
    }

}

protocol SetImageForVariant {
    func setImage(image: Image)
}
