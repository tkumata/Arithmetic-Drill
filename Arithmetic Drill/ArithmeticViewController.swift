//
//  ArithmeticViewController.swift
//  Arithmetic Drill
//
//  Created by KUMATA Tomokatsu on 2016/11/07.
//  Copyright © 2016 KUMATA Tomokatsu. All rights reserved.
//

import UIKit
import AVFoundation

class ArithmeticViewController: UIViewController, UITextFieldDelegate, KeyboardDelegate {

    var answer: Int = 0, userAnswer: Int = 0
    var timer: Timer!
    var tmCounter = 11
    
    var score: Int = 0, hiscore: Int = 0
    var hiaccuracyRate: Double = 0.0
    
    var questionNumber: Int = 0, questionCorrect: Int = 0, questionIncorrect: Int = 0
    var accuracyRate: Double = 0.0
    
    // Initialize variable from UserDefault.
    var levelFromUD: Int = 5
    var burstModeFromUD: Bool = false
    var disable10FromUD: Bool = false

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
    // MARK: When tap Next Question button.
    @IBAction func nextQuestionButton(_ sender: Any) {
        // Stop and initialize timer when timer moves already.
        stopTimer()
        
        // Remove image on screen.
        removeResultImage()
        
        // Initialize
        if disable10FromUD == false {
            tmCounter = 11
        } else {
            tmCounter = 1
        }
        
        userAnswerTxtField.isEnabled = true
        userAnswerTxtField.becomeFirstResponder()
        messageLabel.text = ""
        var questionString = ""
        
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
        if disable10FromUD == false {
            // Timer
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
        questionLabel.text = ""
        messageLabel.text = ""
        messageLabel.layer.cornerRadius = 5.0
        messageLabel.layer.borderWidth = 1.0
        messageLabel.layer.borderColor = UIColor(red:200/255, green:200/255, blue:200/255, alpha:1.0).cgColor
        
        // Read UserDefault
        let defaults = UserDefaults.standard
        levelFromUD = defaults.integer(forKey: "LEVEL")
        burstModeFromUD = defaults.bool(forKey: "BURSTMODE")
        disable10FromUD = defaults.bool(forKey: "DISABLE10")
        hiscore = defaults.integer(forKey: "HISCORE")
        hiaccuracyRate = defaults.double(forKey: "HIRATE")
        
        // Restore hiscore.
        hiscoreLabel.text = "HiScore: " + String(hiscore) + "(" + String(hiaccuracyRate) + "%)"
        
        // textfield delegate.
        userAnswerTxtField.delegate = self
        
        // textfield unavailable when starting.
        userAnswerTxtField.isEnabled = false
        
        // initialize custom keyboard.
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
        keyboardView.delegate = self
        userAnswerTxtField.inputView = keyboardView
        
        // Finaly, start arithmetic drill.
        nextQuestionButton(self)
    }


    // required method for keyboard delegate protocol
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


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopTimer()
        burstModeFromUD = false
        userAnswerTxtField.isEnabled = false
        userAnswerTxtField.resignFirstResponder()
        
        if burstModeFromUD && questionNumber > 1 {
            questionNumber -= 1
            let defaults = UserDefaults.standard
            defaults.set(questionNumber, forKey: "QNUM")
        }
    }


    // MARK: 入力終了 = 答え合わせ
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
            
            playSound()
            
            if tmCounter > 0 {
                score += tmCounter
                messageTmp = "Correct"
            }
            
            // Bonus point
            if tmCounter > 7 {
                score += 10
                messageTmp += " and bounus point"
            }
            
            // Display image
            if burstModeFromUD == false {
                checkResultImg(result: true)
            }
        } else {
            // Incorrect
            questionIncorrect += 1
            
            if tmCounter == 0 {
                messageTmp = "Time up"
            } else {
                messageTmp = "Incorrect\n" + String(answer)
            }
            
            // Display image
            if burstModeFromUD == false {
                checkResultImg(result: false)
            }
        }
        
        messageLabel.text = messageTmp
        
        // Overwrite score with accuracy rate
        if questionCorrect > 0 && questionNumber > 0 {
            // MARK: Update score.
            accuracyRate = Double(questionCorrect * 100 / questionNumber)
            scoreLabel.text = "Score: " + String(score) + "(" + String(accuracyRate) + "%)"
            
            // MARK: Save result to User Default.
            let defaults = UserDefaults.standard
            defaults.set(score, forKey: "SCORE")
            defaults.set(questionNumber, forKey: "QNUM")
            defaults.set(questionCorrect, forKey: "CORRECTNUM")

            // MARK: Update hiscore.
            if score > hiscore {
                hiscore = score
                hiscoreLabel.text = "HiScore: " + String(hiscore) + "(" + String(accuracyRate) + "%)"
                defaults.set(hiscore, forKey: "HISCORE")
                defaults.set(accuracyRate, forKey: "HIRATE")
            }
        }
        
        // Burst mode
        if burstModeFromUD {
            nextQuestionButton(self)
        }
    }


    // MARK: When tap return key.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userAnswerTxtField.resignFirstResponder()
        return true
    }


    // MARK: Function which updates timer.
    func update(tm: Timer) {
        if tmCounter == 0 {
            stopTimer()
            view.endEditing(true)
        } else {
            tmCounter -= 1
            self.messageLabel.text = String(tmCounter) + "sec left"
        }
    }


    // MARK: Function which stops timer.
    func stopTimer() {
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
    }


    // MARK: Function which appears image on screen.
    func checkResultImg(result: Bool) {
        var fileName = ""
        
        if result == true {
            fileName = "Yes.png"
        } else {
            fileName = "No.png"
        }
        
        let rect = CGRect(x: (view.frame.width/2)-120, y: view.frame.height/2, width: 240, height: 240)
        imageView = UIImageView(frame: rect)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: fileName)
        self.view.addSubview(imageView)
    }


    // MARK: Function which remove image on screen.
    func removeResultImage() {
        if imageView != nil {
            imageView.removeFromSuperview()
            imageView.image = nil
        }
    }


    // MARK: Function which play sound.
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
