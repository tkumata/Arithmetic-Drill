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
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var buttonM: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        let vWidth = 320
        let vHeight = 250
        super.init(frame: CGRect(x: 0, y: 0, width: vWidth, height: vHeight))
        initializeSubviews()
    }

    func initializeSubviews() {
        let xibFileName = "KBD" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        
        let borderWidth: Float = 0.5
        
        self.delButtonOutlet.layer.borderWidth = CGFloat(borderWidth)
        self.delButtonOutlet.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        
        self.button1.layer.borderWidth = CGFloat(borderWidth)
        self.button1.layer.borderColor = UIColor.white.cgColor
        
        self.button2.layer.borderWidth = CGFloat(borderWidth)
        self.button2.layer.borderColor = UIColor.white.cgColor
        
        self.button3.layer.borderWidth = CGFloat(borderWidth)
        self.button3.layer.borderColor = UIColor.white.cgColor
        
        self.button4.layer.borderWidth = CGFloat(borderWidth)
        self.button4.layer.borderColor = UIColor.white.cgColor
        
        self.button5.layer.borderWidth = CGFloat(borderWidth)
        self.button5.layer.borderColor = UIColor.white.cgColor
        
        self.button6.layer.borderWidth = CGFloat(borderWidth)
        self.button6.layer.borderColor = UIColor.white.cgColor
        
        self.button7.layer.borderWidth = CGFloat(borderWidth)
        self.button7.layer.borderColor = UIColor.white.cgColor
        
        self.button8.layer.borderWidth = CGFloat(borderWidth)
        self.button8.layer.borderColor = UIColor.white.cgColor
        
        self.button9.layer.borderWidth = CGFloat(borderWidth)
        self.button9.layer.borderColor = UIColor.white.cgColor
        
        self.button0.layer.borderWidth = CGFloat(borderWidth)
        self.button0.layer.borderColor = UIColor.white.cgColor
        
        self.buttonM.layer.borderWidth = CGFloat(borderWidth)
        self.buttonM.layer.borderColor = UIColor.white.cgColor
        
        self.buttonD.layer.borderWidth = CGFloat(borderWidth)
        self.buttonD.layer.borderColor = UIColor.white.cgColor
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
