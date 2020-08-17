//
//  Utilities.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/5/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageByURL(urlString: String) {
    
        guard let url = URL(string: urlString) else {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) {  (data, _, _) in
                    if let data = data {
                        DispatchQueue.main.async {
                           self.image = UIImage(data: data)
                          
                        }
                    }
                }
        dataTask.resume()
    }
}
