//
//  ArithmeticViewController.swift
//  Arithmetic Drill
//
//  Created by KUMATA Tomokatsu on 2016/11/07.
//  Copyright © 2016 KUMATA Tomokatsu. All rights reserved.
//

import UIKit

class ArithmeticViewController: UIViewController, UITextFieldDelegate {

    var answer:Int = 0
    var userAnswer:Int = 0
    var timer:Timer!
    var tmCounter = 11
    var score:Int = 0
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var hiscoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userAnswerTxtField: UITextField!
    
    @IBAction func nextQuestionButton(_ sender: Any) {
        tmCounter = 11
        userAnswerTxtField.isEnabled = true
        userAnswerTxtField.becomeFirstResponder()
        self.messageLabel.text = ""

        let leftTerm1 = Int(arc4random_uniform(20)+1)
        let leftTerm2 = Int(arc4random_uniform(20)+1)
        let kigouNum = Int(arc4random_uniform(3))
        var rightTerm:Int
        var kigou:String = ""
        
        switch kigouNum {
        case 0:
            rightTerm = leftTerm1 + leftTerm2
            kigou = "+"
        case 1:
            rightTerm = leftTerm1 - leftTerm2
            kigou = "-"
        case 2:
            rightTerm = leftTerm1 * leftTerm2
            kigou = "*"
        default:
            rightTerm = leftTerm1 + leftTerm2
            kigou = "+"
        }
        
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
        
        let maskNum = Int(arc4random_uniform(2))
        
        switch maskNum {
        case 0:
            answer = leftTerm1
            self.questionLabel.text = "X" + " " + kigou + " " + String(leftTerm2) + " " + "=" + " " + String(rightTerm)
        case 1:
            answer = leftTerm2
            self.questionLabel.text = String(leftTerm1) + " " + kigou + " " + "X" + " " + "=" + " " + String(rightTerm)
        case 2:
            answer = rightTerm
            self.questionLabel.text = String(leftTerm1) + " " + kigou + " " + String(leftTerm2) + " " + "=" + " " + "X"
        default:
            answer = leftTerm2
            self.questionLabel.text = "X" + " " + kigou + " " + String(leftTerm2) + " " + "=" + " " + String(rightTerm)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.questionLabel.text = ""
        self.messageLabel.text = "Let's arithmetic."
        self.messageLabel.layer.cornerRadius = 10.0
        self.messageLabel.layer.borderWidth = 1.0
        self.messageLabel.layer.borderColor = UIColor(red:200/255, green:200/255, blue:200/255, alpha:1.0).cgColor
        
        // UserDefault
        
        // textfield delegate
        userAnswerTxtField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        timer.invalidate()
        userAnswerTxtField.isEnabled = false
        let userAnswerText = textField.text! as NSString
        userAnswer = (userAnswerText as NSString).integerValue
        
        if (self.answer == userAnswer) {
            self.messageLabel.text = "Correct"
            
            if tmCounter > 0 {
                score += tmCounter
                self.scoreLabel.text = "Score: " + String(score)
            }
        } else {
            if tmCounter == 0 {
                self.messageLabel.text = "Time up"
            } else {
                self.messageLabel.text = "Incorrect\n" + String(answer)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func update(tm: Timer) {
        // do something
        tmCounter -= 1
        self.messageLabel.text = String(tmCounter)
        
        if tmCounter == 0 {
            userAnswerTxtField.isEnabled = false
            timer.invalidate()
        }
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
