//
//  ListBrandViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/31/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ListBrandViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        brands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "brand", for: indexPath)
        cell.textLabel?.text = brands[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if brandSelected != brands[indexPath.row].name {
            brandSelected = brands[indexPath.row].name
            delegate?.setBrand(brand: brandSelected)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.textLabel?.text == brandSelected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    @IBOutlet weak var tbListBrand: UITableView!
    var delegate: SelectBrandDelegate?
    var brands = [Brand]()
    var brandSelected: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategory()
        setup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    func setup() {
        self.title = "Nhãn hiệu"
        tbListBrand.tableFooterView = UIView(frame: .zero)
        tbListBrand.delegate = self
    }
    
    func updateView() {
        tbListBrand.dataSource = self
        tbListBrand.reloadData()
    }
    
    func getCategory() {
        NetworkService.shared.getBrand(onSucess: { (rs) in
            self.brands = [Brand]()
            self.brands.append(contentsOf: rs.brands)
            self.updateView()
        }) { (err) in
            debugPrint(err)
        }
    }
}

protocol SelectBrandDelegate {
    func setBrand(brand: String?)
}



