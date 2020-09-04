//
//  ImageViewController.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/26/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var images:[Image] = []
    var index = 0
    var delegate: UpdateImageDelegate?
    
    @IBOutlet weak var lbIndex: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setData()
    }
    
    func setupView() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(imgPan(panGestureRecognizer: )))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(pan)
        imgView.backgroundColor = .none
        
    }

    @objc func imgPan(panGestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = panGestureRecognizer.translation(in: view)
       
        if translation.y > view.frame.height/5 {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setData() {
        imgView.loadImageByURL(urlString: images[index].full_path)
        
        setLabel()
        setButton()
    }
    
    func setLabel() {
        lbIndex.text = "\(index + 1)/\(images.count)"
    }
    
    @IBAction func handleClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleBack(_ sender: Any) {
        index -= 1
        setData()
    }
    
    @IBAction func handleNext(_ sender: Any) {
        index += 1
        setData()
    }
    
    
    @IBAction func handleDelete(_ sender: Any) {
        self.showVerify(title: "Xóa ảnh ?", mess: nil) {
            self.delegate?.UpdateImage(image: self.images[self.index])
            self.handleClose(self)
        }

    }
    
    func setButton () {
        if index > 0 {
            btnBack.isEnabled = true
        } else {
            btnBack.isEnabled = false
        }
        
        if index + 1 < images.count {
            btnNext.isEnabled = true
        } else {
            btnNext.isEnabled = false
        }
    }

}

protocol UpdateImageDelegate {
    func UpdateImage(image: Image)
}

