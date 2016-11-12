//
//  ArithmeticViewController.swift
//  Arithmetic Drill
//
//  Created by KUMATA Tomokatsu on 2016/11/07.
//  Copyright © 2016 KUMATA Tomokatsu. All rights reserved.
//

import UIKit

class ArithmeticViewController: UIViewController, UITextFieldDelegate {

    var answer: Int = 0
    var userAnswer: Int = 0
    var timer: Timer!
    var tmCounter = 11
    
    var score: Int = 0
    var hiscore: Int = 0
    
    var questionOfNumber: Int = 0
    var questionOfCorrect: Int = 0
    var questionOfIncorrect: Int = 0
    var accuracyRate: Double = 0.0
    
    // Initialize variable from UserDefault.
    var levelFromUD: Int = 5
    var burstModeFromUD: Bool = false
    var disable10FromUD: Bool = false
    
    // 後で消す
    var lastQNum: Int = 0
    var lastQCorre: Int = 0
    var lastQScore: Int = 0
    
    // Outlet
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var hiscoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userAnswerTxtField: UITextField!
    @IBOutlet weak var lastData: UILabel!
    
    // Action
    // MARK: When tap Next Question button.
    @IBAction func nextQuestionButton(_ sender: Any) {
        // Stop and initialize timer when timer moves already.
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
        
        // Initialize
        if disable10FromUD == false {
            tmCounter = 11
        } else {
            tmCounter = 1
        }
        
        userAnswerTxtField.isEnabled = true
        userAnswerTxtField.becomeFirstResponder()
        messageLabel.text = ""
        var questionString: String = ""
        
        // Make question parts.
        var leftTerm1 = 0
        var leftTerm2 = 0
        switch levelFromUD {
        case 1:
            leftTerm1 = Int(arc4random_uniform(9)+1)
            leftTerm2 = Int(arc4random_uniform(9)+1)
        case 2:
            leftTerm1 = Int(arc4random_uniform(11)+1)
            leftTerm2 = Int(arc4random_uniform(11)+1)
        case 3:
            leftTerm1 = Int(arc4random_uniform(13)+1)
            leftTerm2 = Int(arc4random_uniform(13)+1)
        case 4:
            leftTerm1 = Int(arc4random_uniform(15)+1)
            leftTerm2 = Int(arc4random_uniform(15)+1)
        case 5:
            leftTerm1 = Int(arc4random_uniform(20)+1)
            leftTerm2 = Int(arc4random_uniform(20)+1)
        case 6:
            leftTerm1 = Int(arc4random_uniform(25)+1)
            leftTerm2 = Int(arc4random_uniform(25)+1)
        case 7:
            leftTerm1 = Int(arc4random_uniform(30)+1)
            leftTerm2 = Int(arc4random_uniform(30)+1)
        case 8:
            leftTerm1 = Int(arc4random_uniform(35)+1)
            leftTerm2 = Int(arc4random_uniform(35)+1)
        case 9:
            leftTerm1 = Int(arc4random_uniform(40)+1)
            leftTerm2 = Int(arc4random_uniform(40)+1)
        case 10:
            leftTerm1 = Int(arc4random_uniform(45)+1)
            leftTerm2 = Int(arc4random_uniform(45)+1)
        default:
            leftTerm1 = Int(arc4random_uniform(50)+1)
            leftTerm2 = Int(arc4random_uniform(50)+1)
        }
        let kigouNum = Int(arc4random_uniform(3))
        var rightTerm: Int = 0
        var kigou: String = ""
        
        // 記号の生成
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
        
        // Decide masking part.
        let maskNum = Int(arc4random_uniform(2))
        
        // Display question.
        switch maskNum {
        case 0:
            answer = leftTerm1
            questionString = "X " + kigou + " " + String(leftTerm2) + " = " + String(rightTerm)
        case 1:
            answer = leftTerm2
            questionString = String(leftTerm1) + " " + kigou + " X" + " = " + String(rightTerm)
        case 2:
            answer = rightTerm
            questionString = String(leftTerm1) + " " + kigou + " " + String(leftTerm2) + " = X"
        default:
            answer = leftTerm2
            questionString = "X " + kigou + " " + String(leftTerm2) + " = " + String(rightTerm)
        }
        self.questionLabel.text = questionString
        questionOfNumber += 1
        
        // Make timer.
        if disable10FromUD == false {
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(self.update),
                                         userInfo: nil,
                                         repeats: true)
            
            // Start timer.
            timer.fire()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.questionLabel.text = "e.g, X - 12 = 7"
        self.messageLabel.text = "Let's arithmetic."
        self.messageLabel.layer.cornerRadius = 10.0
        self.messageLabel.layer.borderWidth = 1.0
        self.messageLabel.layer.borderColor = UIColor(red:200/255, green:200/255, blue:200/255, alpha:1.0).cgColor
        
        // Read UserDefault
        let defaults = UserDefaults.standard
        levelFromUD = defaults.integer(forKey: "LEVEL")
        burstModeFromUD = defaults.bool(forKey: "BURSTMODE")
        disable10FromUD = defaults.bool(forKey: "DISABLE10")
        hiscore = defaults.integer(forKey: "HISCORE")
        
        // 後で消す BEGIN
        lastQNum = defaults.integer(forKey: "QNUM")
        lastQCorre = defaults.integer(forKey: "CORRECTNUM")
        lastQScore = defaults.integer(forKey: "SCORE")
        lastData.text = "Your last data.\n" +
            "Score: " + String(lastQScore) +
            "\nQuestion: " + String(lastQNum) +
            "\nCorrect: " + String(lastQCorre) +
            "\nLevel: " + String(levelFromUD)
        // 後で消す END
        
        // Restore hiscore.
        hiscoreLabel.text = "HiScore: " + String(hiscore)
        
        // textfield delegate.
        userAnswerTxtField.delegate = self
        
        // textfield unavailable when starting.
        userAnswerTxtField.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop timer.
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
        
        burstModeFromUD = false
        userAnswerTxtField.isEnabled = false
        userAnswerTxtField.resignFirstResponder()
    }
    
    // MARK: 入力終了 = 答え合わせ
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        // Stop timer.
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
        
        // Unavailable textfield.
        userAnswerTxtField.isEnabled = false
        userAnswerTxtField.resignFirstResponder()
        
        // Get textfield value.
        let userAnswerText = textField.text! as NSString
        
        // Convert cast.
        userAnswer = (userAnswerText as NSString).integerValue
        
        var messTmp: String = ""
        if (self.answer == userAnswer) {
            // Correct
            questionOfCorrect += 1
            
            if tmCounter > 0 {
                score += tmCounter
                messTmp = "Correct"
            }
            
            // Bonus point
            if tmCounter > 7 {
                score += 10
                messTmp += " and bounus point"
            }
        } else {
            // Incorrect
            questionOfIncorrect += 1
            
            if tmCounter == 0 {
                messTmp = "Time up"
            } else {
                messTmp = "Incorrect\n" + String(answer)
            }
        }
        
        messageLabel.text = messTmp
        
        // Overwrite score with accuracy rate
        if questionOfCorrect > 0 && questionOfNumber > 0 {
            accuracyRate = Double(questionOfCorrect * 100 / questionOfNumber)
            scoreLabel.text = "Score: " + String(score) + "(" + String(accuracyRate) + "%)"
            
            // Save result to User Default.
            let defaults = UserDefaults.standard
            defaults.set(score, forKey: "SCORE")
            defaults.set(questionOfNumber, forKey: "QNUM")
            defaults.set(questionOfCorrect, forKey: "CORRECTNUM")

            // Update hiscore.
            if score > hiscore {
                hiscore = score
                hiscoreLabel.text = "HiScore: " + String(hiscore)
                defaults.set(hiscore, forKey: "HISCORE")
            }
        }
        
        // Burst mode
        if burstModeFromUD {
            nextQuestionButton(self)
        }
    }
    
    // MARK: When tap return key.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        view.endEditing(true)
//        return false
        userAnswerTxtField.resignFirstResponder()
        return true
    }
    
    // MARK: timer update function.
    func update(tm: Timer) {
        tmCounter -= 1
        self.messageLabel.text = String(tmCounter)
        
        if tmCounter == 0 {
            view.endEditing(true)
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
