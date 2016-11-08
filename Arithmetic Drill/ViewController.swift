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
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    
    // 各画面から戻るボタン
    @IBAction func backToHome (segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.startButtonOutlet.layer.cornerRadius = 10.0
        self.startButtonOutlet.layer.borderWidth = 1.0
        self.startButtonOutlet.layer.borderColor = UIColor(red:0/255, green:122/255, blue:255/255, alpha:1.0).cgColor
        self.settingsButtonOutlet.layer.cornerRadius = 10.0
        self.settingsButtonOutlet.layer.borderWidth = 1.0
        self.settingsButtonOutlet.layer.borderColor = UIColor(red:0/255, green:122/255, blue:255/255, alpha:1.0).cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

