//
//  KeyboardViewController.swift
//  CustomKBD
//
//  Created by KUMATA Tomokatsu on 2016/11/13.
//  Copyright © 2016 KUMATA Tomokatsu. All rights reserved.
//

import UIKit

protocol KeyboardDelegate: class {
    func keyWasTapped(character: String)
    func keyDone()
    func backspace()
}

class Keyboard: UIView {

    var delegate: KeyboardDelegate?
    
    @IBOutlet weak var delButtonOutlet: UIButton!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }

    func initializeSubviews() {
        let xibFileName = "KBD" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        
        self.delButtonOutlet.layer.cornerRadius = 5.0
        self.delButtonOutlet.layer.borderWidth = 1.0
        self.delButtonOutlet.layer.borderColor = UIColor(red:0/255, green:122/255, blue:255/255, alpha:1.0).cgColor
    }
    
    @IBAction func keyTapped(sender: UIButton) {
        // When a button is tapped, send that information to the
        // delegate (ie, the view controller)
        self.delegate?.keyWasTapped(character: sender.titleLabel!.text!) // could alternatively send a tag value
    }
    
    @IBAction func Done(sender: UIButton) {
        self.delegate?.keyDone()
    }
    
    @IBAction func backspace(sender: UIButton) {
        self.delegate?.backspace()
    }


}
