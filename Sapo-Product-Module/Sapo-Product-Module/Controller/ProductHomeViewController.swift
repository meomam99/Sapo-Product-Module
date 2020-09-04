//
//  ProductHomeViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/5/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ProductHomeViewController: UIViewController {

    
    
    @IBOutlet weak var addProductView: UIView!
    @IBOutlet weak var listProductView: UIView!
    @IBOutlet weak var importProductView: UIView!
    @IBOutlet weak var checkProductView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
     //   navigationController?.navigationItem.rightBarButtonItem = .none
     //   navigationController?.navigationBar.backItem?.backBarButtonItem = .none
        self.title = "Sản phẩm"
        addProductView.layer.cornerRadius = 12
        setupView()
    }
    
    func setupView() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(viewAddProductTapped(tapGestureRecognizer: )))
        addProductView.isUserInteractionEnabled = true
        addProductView.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(viewListProductTapped(tapGestureRecognizer: )))
         listProductView.isUserInteractionEnabled = true
         listProductView.addGestureRecognizer(tapGesture2)
    }
      @objc func viewAddProductTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let controller: ProductAddViewController = storyboard?.instantiateViewController(identifier: "productAdd") as! ProductAddViewController
    
        controller.editMode = .add
        navigationController?.pushViewController(controller, animated: true)
             
       
    }
    
      @objc func viewListProductTapped(tapGestureRecognizer: UITapGestureRecognizer) {
            let controller: ProductListViewController = storyboard?.instantiateViewController(identifier: "productList") as! ProductListViewController
        
        navigationController?.pushViewController(controller, animated: true)
                 
        
    }
    
    
    
    @IBAction func showListProduct(_ sender: Any) {
          let controller: ProductListViewController = storyboard?.instantiateViewController(identifier: "productList") as! ProductListViewController
        
           //  controller.navigationController?.title = "Chi tiết sản phẩm"
                navigationController?.pushViewController(controller, animated: true)
    }
    
    
    

}
