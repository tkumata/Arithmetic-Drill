//
//  ViewController.swift
//  Arithmetic Drill
//
//  Created by KUMATA Tomokatsu on 2016/11/07.
//  Copyright © 2016 KUMATA Tomokatsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var otherButtonOutlet: UIButton!
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        startButtonOutlet.layer.cornerRadius = 5.0
        startButtonOutlet.layer.borderWidth = 1.0
        startButtonOutlet.layer.borderColor = UIColor(red:0/255, green:122/255, blue:255/255, alpha:1.0).cgColor
        
        otherButtonOutlet.layer.cornerRadius = 5.0
        otherButtonOutlet.layer.borderWidth = 1.0
        otherButtonOutlet.layer.borderColor = UIColor(red:0/255, green:122/255, blue:255/255, alpha:1.0).cgColor
        
        settingsButtonOutlet.layer.cornerRadius = 5.0
        settingsButtonOutlet.layer.borderWidth = 1.0
        settingsButtonOutlet.layer.borderColor = UIColor(red:0/255, green:122/255, blue:255/255, alpha:1.0).cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

