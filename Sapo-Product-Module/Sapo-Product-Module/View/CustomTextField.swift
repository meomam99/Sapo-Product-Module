//
//  CustomTextField.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/27/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    var header: String = ""
    var floatingLabel = UILabel(frame: .zero)
    
    required init?(coder aDecoder: NSCoder) {
 
        super.init(coder: aDecoder)
        setupView()
        header = self.placeholder ?? ""
        self.floatingLabel = UILabel(frame: CGRect.zero)
     //   self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
     //   self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
        self.addTarget(self, action: #selector(self.updateFloatingLabel), for: .editingChanged)
    }
    
    
    
    func setupView() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height , width: self.frame.width, height: 1)
        bottomLine.backgroundColor = .init(srgbRed: 192/255, green: 192/255, blue: 192/255, alpha: 1)
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
    }
    
    func updateHeaderFloatingLabel(header: String?) {
        if let header = header {
            self.header = header
        }
        updateFloatingLabel()
     }
    
     @objc func updateFloatingLabel() {
        if self.text == "" {
            removeFloatingLabel()
        } else {
            addFloatingLabel()
        }
    }
    
    // Add a floating label to the view on becoming first responder
     @objc func addFloatingLabel() {

        self.floatingLabel.layer.backgroundColor = UIColor.white.cgColor
        self.floatingLabel.clipsToBounds = true
        self.floatingLabel.frame = CGRect(x: 0, y: -15, width: self.frame.width, height: 15)
        self.floatingLabel.textAlignment = .left
        self.floatingLabel.font = self.floatingLabel.font.withSize(12)
        self.floatingLabel.text = header
        self.addSubview(self.floatingLabel)
        self.placeholder = ""
        self.bringSubviewToFront(subviews.last!)
        self.setNeedsDisplay()
     }
    
    func addBottomBlueLine() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height , width: (self.center.x - self.frame.origin.x)*2, height: 1)
        
        bottomLine.backgroundColor = UIColor.systemBlue.cgColor
        
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
    }
     
     @objc func removeFloatingLabel() {
             UIView.animate(withDuration: 0.1) {
                 self.subviews.forEach{ $0.removeFromSuperview() }
                 self.setNeedsDisplay()
             }
            self.placeholder = header
     }
     
    
}
