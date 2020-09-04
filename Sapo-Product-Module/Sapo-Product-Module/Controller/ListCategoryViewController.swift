//
//  ListCategoryViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/14/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ListCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categorySelected.name != categories[indexPath.row].name {
            categorySelected = categories[indexPath.row]
         
            delegate?.setCategory(category: categorySelected)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.textLabel?.text == categorySelected.name {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    var delegate: SelectCategory?

    var categories = [Category()]
    var categorySelected: Category = Category()
    

    @IBOutlet weak var tbviewListCategory: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategory()
        setup()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    func setup() {
        self.title = "Danh mục"
        tbviewListCategory.tableFooterView = UIView(frame: .zero)
        tbviewListCategory.delegate = self
    }
    
    func updateView() {
        tbviewListCategory.dataSource = self
        tbviewListCategory.reloadData()
    }
    
    func getCategory() {
        NetworkService.shared.getCategory(onSucess: { (ResultCategory) in
            self.categories = [Category()]
            self.categories.append(contentsOf: ResultCategory.categories)
            self.updateView()
        }) { (err) in
            debugPrint(err)
        }
    }
}

protocol SelectCategory {
    func setCategory(category: Category)
}
