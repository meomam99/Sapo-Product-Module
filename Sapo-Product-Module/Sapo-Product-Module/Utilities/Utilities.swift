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

extension CALayer {
    func setBorderSilver() {
        self.cornerRadius = 8
        self.borderColor = .init(srgbRed: 214/255, green: 214/255, blue: 214/255, alpha: 1)
        self.borderWidth = 0.5

    }
    
    func setBorderRed() {
        self.cornerRadius = 5
        self.borderColor = .init(srgbRed: 1, green: 0, blue: 0, alpha: 1)
        self.borderWidth = 0.5

    }
    
    func setShadow() {
        self.shadowColor = .init(srgbRed: 192/255, green: 192/255, blue: 192/255, alpha: 1)
        self.shadowRadius = 8
        self.shadowOffset = CGSize(width: 5, height: 5)
        self.shadowOpacity = 0.5
    }
}

extension UITextField {
    func AddBottomLine() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height + 5, width: (self.center.x - self.frame.origin.x)*2, height: 1)

        bottomLine.backgroundColor = .init(srgbRed: 192/255, green: 192/255, blue: 192/255, alpha: 1)

        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
    }
}

extension UIViewController {
    func showMessage(flag: Bool, mess: String, onCompletion:@escaping () -> Void ) {
        var style:UIAlertAction.Style
        if flag {
            style = .cancel
        } else {
            style = .destructive
        }

        let alert = UIAlertController(title: mess, message: nil, preferredStyle: .alert)
        
        let btnOK = UIAlertAction(title: "OK", style: style) { (btn) in
            onCompletion()
        }
        alert.addAction(btnOK)
        self.present(alert, animated: true)
    }
}
