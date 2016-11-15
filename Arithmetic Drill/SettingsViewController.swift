//
//  SettingsViewController.swift
//  Arithmetic Drill
//
//  Created by KUMATA Tomokatsu on 2016/11/07.
//  Copyright © 2016 KUMATA Tomokatsu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    //
    let userData = UserDefaults.standard
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var settingContentsView: UIView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelStepperOutlet: UIStepper!
    @IBOutlet weak var burstModeOutlet: UISwitch!
    @IBOutlet weak var disable10Outlet: UISwitch!
    @IBOutlet weak var kukuModeOutlet: UISwitch!
    
    // MARK: Level stepper.
    @IBAction func levelStepperAction(_ sender: UIStepper) {
        let levelNum = Int(sender.value)
        levelLabel.text = String(levelNum)
        userData.set(levelNum, forKey: "LEVEL")
    }


    // MARK: Burst mode switch.
    @IBAction func burstModeAction(_ sender: UISwitch) {
        userData.set(sender.isOn, forKey: "BURSTMODE")
    }


    // MARK: Disable 10 count switch.
    @IBAction func disable10Action(_ sender: UISwitch) {
        userData.set(sender.isOn, forKey: "DISABLE10")
    }

    @IBAction func kukuModeAction(_ sender: UISwitch) {
        userData.set(sender.isOn, forKey: "99MODE")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // MARK: Scroll View Setting
        let scrollFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        myScrollView.frame = scrollFrame
        let contentsRect = settingContentsView.bounds
        myScrollView.contentSize = CGSize(width: contentsRect.width, height: contentsRect.height)


        // MARK: Set value from User Defaults.
        let levelFromUD = userData.integer(forKey: "LEVEL")

        if case 1...10 = levelFromUD {
            levelLabel.text = String(levelFromUD)
            levelStepperOutlet.value = Double(levelFromUD)
        } else {
            levelLabel.text = String("5")
            userData.set("5", forKey: "LEVEL")
        }
        
        burstModeOutlet.isOn = userData.bool(forKey: "BURSTMODE")
        disable10Outlet.isOn = userData.bool(forKey: "DISABLE10")
        kukuModeOutlet.isOn = userData.bool(forKey: "99MODE")
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
