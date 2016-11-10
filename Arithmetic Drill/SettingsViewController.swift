//
//  SettingsViewController.swift
//  Arithmetic Drill
//
//  Created by KUMATA Tomokatsu on 2016/11/07.
//  Copyright © 2016 KUMATA Tomokatsu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var settingContentsView: UIView!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBAction func levelStepperAction(_ sender: UIStepper) {
        let levelNum = Int(sender.value)
        levelLabel.text = String(levelNum)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Scroll View Setting
        let scrollFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        myScrollView.frame = scrollFrame
        let contentsRect = settingContentsView.bounds
        myScrollView.contentSize = CGSize(width: contentsRect.width, height: contentsRect.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
