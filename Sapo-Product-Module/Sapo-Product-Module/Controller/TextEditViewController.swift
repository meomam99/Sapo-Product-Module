//
//  TextEditViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 9/3/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class TextEditViewController: UIViewController, UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }

    @IBOutlet weak var textView: UITextView!
    var text: String?
    var isEditMode = true
    var delegate: TextEditDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.delegate = self
    }
    
    func setupView() {
        textView.text = text
        if isEditMode  {
            textView.isEditable = true
            navigationItem.rightBarButtonItems?[0].isEnabled = true
        } else {
            textView.isEditable = false
            navigationItem.rightBarButtonItems?[0].isEnabled = false
        }
    }
 
     @IBAction func sumbit(_ sender: Any) {
        delegate?.update(text: textView.text)
        self.navigationController?.popViewController(animated: true)
     }
  

}

protocol TextEditDelegate {
    func update(text: String)
    
}
