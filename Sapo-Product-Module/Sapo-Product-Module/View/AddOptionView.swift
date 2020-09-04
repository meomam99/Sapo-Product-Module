//
//  AddOptionView.swift
//  Sapo-Product-Module
//
//  Created by mac on 8/31/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class AddOptionView: UIView {

    var options = [Option]()
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var lbOpt1: UILabel!
    @IBOutlet weak var lbOpt1Value: UILabel!
    @IBOutlet weak var lbOpt2: UILabel!
    @IBOutlet weak var lbOpt2Value: UILabel!
    @IBOutlet weak var lbOpt3: UILabel!
    @IBOutlet weak var lbOpt3Value: UILabel!
    
    override func awakeFromNib() {
        setupView()
    }

    func setupView () {
        options = []
        view1.isHidden = true
        view2.isHidden = true
        view3.isHidden = true
  
    }
    
    func setData(options: [Option]) {
        self.options = options
        updateView()
    }

    func getOptionsCombination() -> [Opt] {
        var optionsCombine = [Opt]()
        let option1 = getOption1()
        let option2 = getOption2()
        let option3 = getOption3()
        for i in option1.values {
            for j in option2.values {
                for k in option3.values {
                    optionsCombine.append(Opt(opt1: i, opt2: j, opt3: k))
                }
            }
        }
        return optionsCombine
    }
    
    func getOption() -> [Option] {
        return self.options
    }
    
    func getOption1() -> Option {
        
        if !options.isEmpty {
            return options[0]
        } else { return Option(name: nil, values: [nil]) }
    }
    
    func getOption2() -> Option {
        if options.count > 1 {
            return options[1]
        } else { return Option(name: nil, values: [nil]) }
    }
    
    func getOption3() -> Option {
        
        if options.count > 2 {
            return options[2]
        } else { return Option(name: nil, values: [nil]) }
    }
    
    func addOption(name: String, value: [String]) {
        if options.count < 3 {
            options.append(Option(name: name, values: value))
            updateView()
        }

    }
    
    func removeOption() {

        if !options.isEmpty {
            options.removeLast(1)
            updateView()
        }
    }
    
    func getValueText(values: [String?]) -> String {
        var rs = ""
        for i in 0..<values.count {
            if let value = values[i] {
                rs = rs + value
                if i < values.count - 1 {
                    rs += " | "
                }
            }
        }
        return rs
    }
    
    func updateView() {
        if let name = getOption1().name {
            view1.isHidden = false
            lbOpt1.text = name
            lbOpt1Value.text = getValueText(values: getOption1().values)
        } else {
            view1.isHidden = true
        }

        if let name = getOption2().name {
              view2.isHidden = false
              lbOpt2.text = name
              lbOpt2Value.text = getValueText(values: getOption2().values)
        } else {
            view2.isHidden = true
        }
        
        if let name = getOption3().name {
              view3.isHidden = false
              lbOpt3.text = name
              lbOpt3Value.text = getValueText(values: getOption3().values)
          } else {
              view3.isHidden = true
          }
        
    }
    
    func numberOfOptions() -> Int {
        return options.count
    }
}
