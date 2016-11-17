//
//  ArithmeticViewController.swift
//  Arithmetic Drill
//
//  Created by KUMATA Tomokatsu on 2016/11/07.
//  Copyright © 2016 KUMATA Tomokatsu. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox.AudioServices

class ArithmeticViewController: UIViewController, UITextFieldDelegate, KeyboardDelegate {

    // Read User Default
    let userData = UserDefaults.standard
    
    var answer: Int = 0, userAnswer: Int = 0
    var timer: Timer!
    var timerCounter: Int = 11
    
    var score: Int = 0, hiscore: Int = 0
    var hiAccuracyRate: Double = 0.0
    
    var questionNumber: Int = 0, questionCorrect: Int = 0, questionIncorrect: Int = 0
    var accuracyRate: Double = 0.0
    
    // Initialize variable from User Default.
    var levelOnSettings: Int = 5
    var burstModeOnSettings: Bool = false
    var disable10OnSettings: Bool = false
    var kukuModeOnSettings: Bool = false

    // Image of result of checking answer.
    var imageView: UIImageView!
    
    // Sound of answer is correct.
    var player: AVAudioPlayer?
    
    // Outlet
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var hiscoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userAnswerTxtField: UITextField!
    
    // Action
    // MARK: - When tap Next Question button.
    @IBAction func nextQuestionButton(_ sender: Any) {
        // Stop and initialize timer when timer moves already.
        stopTimer()
        
        // Remove image on screen.
        removeResultImage()
        
        // Ready to textfield.
        userAnswerTxtField.isEnabled = true
        userAnswerTxtField.becomeFirstResponder()
        messageLabel.text = ""
        
        // Initialize
        var questionString: String = ""
        var leftTerm1: Int = 0
        var leftTerm2: Int = 0
        var kigouNum: Int = 3
        var rightTerm: Int = 0
        var kigou: String = ""
        
        if kukuModeOnSettings {
            levelOnSettings = 1
        }
        
        // Make question parts.
        switch levelOnSettings {
        case 1:
            leftTerm1 = Int(arc4random_uniform(9)+1) // 0~8 + 1 = 1~9
            leftTerm2 = Int(arc4random_uniform(9)+1)
        case 2:
            leftTerm1 = Int(arc4random_uniform(15)+1) // 0~14 + 1 = 1~15
            leftTerm2 = Int(arc4random_uniform(15)+1)
        case 3:
            leftTerm1 = Int(arc4random_uniform(15)+1) // 0~14 + 1 = 1~15
            leftTerm2 = Int(arc4random_uniform(15)+1)
        case 4:
            leftTerm1 = Int(arc4random_uniform(20)+1) // 0~19 + 1 = 1~20
            leftTerm2 = Int(arc4random_uniform(20)+1)
        case 5:
            leftTerm1 = Int(arc4random_uniform(16)+5) // 0~15 + 5 = 5~20
            leftTerm2 = Int(arc4random_uniform(16)+5)
        case 6:
            leftTerm1 = Int(arc4random_uniform(19)+5) // 0~20 + 5 = 5~25
            leftTerm2 = Int(arc4random_uniform(19)+5)
        case 7:
            leftTerm1 = Int(arc4random_uniform(36)+5) // 0~35 + 5 = 5~40
            leftTerm2 = Int(arc4random_uniform(36)+5)
        case 8:
            leftTerm1 = Int(arc4random_uniform(49)+5) // 0~40 + 5 = 5~50
            leftTerm2 = Int(arc4random_uniform(49)+5)
        case 9:
            leftTerm1 = Int(arc4random_uniform(56)+5) // 0~55 + 5 = 5~60
            leftTerm2 = Int(arc4random_uniform(56)+5)
        case 10:
            leftTerm1 = Int(arc4random_uniform(51)+5) // 0~50 + 10 = 10~60
            leftTerm2 = Int(arc4random_uniform(51)+5)
        default:
            leftTerm1 = Int(arc4random_uniform(16)+5) // same a level 5
            leftTerm2 = Int(arc4random_uniform(16)+5)
        }

        if levelOnSettings > 0 && levelOnSettings < 3 {
            kigouNum = Int(arc4random_uniform(2))
        } else if kukuModeOnSettings {
            kigouNum = 2
        } else {
            kigouNum = Int(arc4random_uniform(3))
        }
        
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
        let maskNum = Int(arc4random_uniform(3))
        
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
        
        // Make timer.
        if disable10OnSettings == false {
            timerCounter = 11
            
            // Timer
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(self.update),
                                         userInfo: nil,
                                         repeats: true)
            // Start timer.
            timer.fire()
        } else {
            timerCounter = 1
        }
    }


    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Attributes.
        questionLabel.text = ""
        messageLabel.text = ""
        messageLabel.layer.cornerRadius = 5.0
        messageLabel.layer.borderWidth = 1.0
        messageLabel.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
        
        // Read settings in User Default.
        levelOnSettings = userData.integer(forKey: "LEVEL")
        burstModeOnSettings = userData.bool(forKey: "BURSTMODE")
        disable10OnSettings = userData.bool(forKey: "DISABLE10")
        kukuModeOnSettings = userData.bool(forKey: "99MODE")
        hiscore = userData.integer(forKey: "HISCORE")
        hiAccuracyRate = userData.double(forKey: "HIRATE")
        
        // Restore hiscore.
        hiscoreLabel.text = "HiScore: " + String(hiscore) + "(" + String(hiAccuracyRate) + "%)"
        
        // textfield delegate.
        userAnswerTxtField.delegate = self
        
        // textfield unavailable when starting.
        userAnswerTxtField.isEnabled = false
        
        // initialize custom keyboard.
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        keyboardView.delegate = self
        userAnswerTxtField.inputView = keyboardView
        
        // Finaly, start arithmetic drill.
        nextQuestionButton(self)
    }


    // MARK: - required method for keyboard delegate protocol
    func keyWasTapped(character: String) {
        userAnswerTxtField.insertText(character)
    }
    func keyDone() {
        view.endEditing(true)
    }
    func backspace() {
        userAnswerTxtField.deleteBackward()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - View will disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
        
        burstModeOnSettings = false
        userAnswerTxtField.isEnabled = false
        userAnswerTxtField.resignFirstResponder()
        
        if burstModeOnSettings && questionNumber > 1 {
            questionNumber -= 1
            userData.set(questionNumber, forKey: "QNUM")
        }
    }


    // MARK: - 入力終了(キーボードが退場) = 答え合わせ
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        var messageTmp: String = ""
        
        // Stop timer.
        stopTimer()
        
        // Increase number.
        questionNumber += 1
        
        // Unavailable textfield.
        userAnswerTxtField.isEnabled = false
        userAnswerTxtField.resignFirstResponder()
        
        // Get textfield value.
        let userAnswerText = textField.text! as NSString
        // Convert cast.
        userAnswer = (userAnswerText as NSString).integerValue
        
        // MARK: Check answer.
        if (self.answer == userAnswer) {
            // Correct
            questionCorrect += 1

            // Play sound. If silend mode, vibrate.
            playSound()
            
            if timerCounter > 0 {
                score += timerCounter
                messageTmp = "Correct"
            }
            
            // Bonus point
            if timerCounter > 7 {
                score += 10
                messageTmp += " and bounus point"
            }
            
            // Display image
            if burstModeOnSettings == false {
                checkResultImg(result: true)
            }
        } else {
            // Incorrect
            questionIncorrect += 1
            
            if timerCounter == 0 {
                messageTmp = "Time up"
            } else {
                messageTmp = "Incorrect\n" + String(answer)
            }
            
            // Display image
            if burstModeOnSettings == false && userAnswer != 0 {
                checkResultImg(result: false)
            }
        }
        
        // Display message.
        messageLabel.text = messageTmp
        
        // Overwrite score with accuracy rate
        if questionCorrect > 0 && questionNumber > 0 {
            // Update score.
            accuracyRate = Double(questionCorrect * 100 / questionNumber)
            scoreLabel.text = "Score: " + String(score) + "(" + String(accuracyRate) + "%)"
            
            // Save result to User Default.
            userData.set(score, forKey: "SCORE")
            userData.set(questionNumber, forKey: "QNUM")
            userData.set(questionCorrect, forKey: "CORRECTNUM")

            // Update hiscore.
            if score > hiscore {
                hiscore = score
                hiscoreLabel.text = "HiScore: " + String(hiscore) + "(" + String(accuracyRate) + "%)"
                userData.set(hiscore, forKey: "HISCORE")
                userData.set(accuracyRate, forKey: "HIRATE")
            }
        }
        
        // Burst mode
        if burstModeOnSettings {
            nextQuestionButton(self)
        }
    }


    // MARK: - When tap return key.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userAnswerTxtField.resignFirstResponder()
        return true
    }


    // MARK: - Function which updates timer.
    func update(tm: Timer) {
        if timerCounter == 0 {
            stopTimer()
            view.endEditing(true)
        } else {
            timerCounter -= 1
            self.messageLabel.text = String(timerCounter) + " sec left"
        }
    }


    // MARK: - Function which stops timer.
    func stopTimer() {
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
    }


    // MARK: - Function which appears image on screen.
    func checkResultImg(result: Bool) {
        var fileName: String = ""
        
        if result == true {
            fileName = "Yes.png"
        } else {
            fileName = "No.png"
        }
        
        let rect = CGRect(x: (view.frame.width/2)-(view.frame.width*0.65)/2,
                          y: (view.frame.height/2)-(view.frame.height/2)/2+(view.frame.height*0.1),
                          width: view.frame.width*0.65,
                          height: view.frame.height*0.65)
        imageView = UIImageView(frame: rect)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: fileName)
        self.view.addSubview(imageView)
    }


    // MARK: - Function which remove image on screen.
    func removeResultImage() {
        if imageView != nil {
            imageView.removeFromSuperview()
            imageView.image = nil
        }
    }


    // MARK: - Function which play sound.
    func playSound() {
        guard let url = Bundle.main.url(forResource: "chime", withExtension: "mp3") else {
            print("url not found")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
            
            // Um, I seem this is bad idea.
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        } catch let error {
            print(error.localizedDescription)
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
