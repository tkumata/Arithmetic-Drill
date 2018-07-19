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
import MultipeerConnectivity

class ArithmeticViewController: UIViewController, UITextFieldDelegate, KeyboardDelegate, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCBrowserViewControllerDelegate {
    // Read User Default
    let userData = UserDefaults.standard
    
    var maskedAnswer: Int = 0, userAnswer: Int = 0
    var timer: Timer!
    var timerCounter: Int = 11
    
    var score: Int = 0, hiscore: Int = 0
    var hiAccuracyRate: Double = 0.0
    
    var questionNumber: Int = 0, questionCorrect: Int = 0, questionIncorrect: Int = 0
    var accuracyRate: Double = 0.0
    
    // Initialize variable from User Default.
    var settingsLevel: Int = 5
    var settingsBurstMode: Bool = false
    var settingsDisable10: Bool = false
    var settingsKukuMode: Bool = false
    var settingContinue: Bool = false

    // Image of result of checking answer.
    var imageView: UIImageView!
    
    // Sound of answer is correct.
    var player: AVAudioPlayer?
    
    // Peer connectivity.
    let serviceType = "ArithmeticDrill"
    let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    var mySession: MCSession!
    var serviceAdvertiser: MCNearbyServiceAdvertiser!
    var serviceAdvertiserAssistant: MCAdvertiserAssistant!
    var browser: MCNearbyServiceBrowser!
    
    // Outlet
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var hiscoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userAnswerTxtField: UITextField!
    @IBOutlet weak var vsModeButtonOutlet: UIButton!
    
    // Action
    // MARK: - Start multipeer browsing.
    @IBAction func vsModeButtonAction(_ sender: UIButton) {
        let Browser = MCBrowserViewController(serviceType: serviceType, session: mySession)
        Browser.delegate = self
        present(Browser, animated: true)
    }
    
    // MARK: - When tap Next Question button.
    @IBAction func nextQuestionButton(_ sender: Any) {
        // Stop and initialize timer when timer moves already.
        stopTimer()
        
        // MARK: Prepare textfield.
        userAnswerTxtField.isEnabled = true
        userAnswerTxtField.becomeFirstResponder()
        messageLabel.text = ""
        
        // MARK: Initialize
        var questionString: String = ""
        var leftTerm1: Int = 0
        var leftTerm2: Int = 0
        var mathSymbolNum: Int = 3
        var mathSymbol: String = ""
        var rightTerm: Int = 0
        
        if settingsKukuMode {
            settingsLevel = 1
        }
        
        // MARK: Make question parts.
        switch settingsLevel {
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
            leftTerm1 = Int(arc4random_uniform(21)+5) // 0~20 + 5 = 5~25
            leftTerm2 = Int(arc4random_uniform(21)+5)
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

        // MARK: Make mathematic symbol.
        if settingsLevel > 0 && settingsLevel < 3 {
            mathSymbolNum = Int(arc4random_uniform(2))
        } else {
            mathSymbolNum = Int(arc4random_uniform(3))
        }

        if settingsKukuMode {
            mathSymbolNum = 2
        }
        
        switch mathSymbolNum {
        case 0:
            rightTerm = leftTerm1 + leftTerm2
            mathSymbol = "+"
        case 1:
            rightTerm = leftTerm1 - leftTerm2
            mathSymbol = "-"
        case 2:
            rightTerm = leftTerm1 * leftTerm2
            mathSymbol = "*"
        default:
            rightTerm = leftTerm1 + leftTerm2
            mathSymbol = "+"
        }
        
        // MARK: Decide masking part.
        let maskNumber = Int(arc4random_uniform(3)) // 0, 1, 2
        
        // MARK: Display question.
        switch maskNumber {
        case 0:
            maskedAnswer = leftTerm1
            questionString = "X " + mathSymbol + " " + String(leftTerm2) + " = " + String(rightTerm)
        case 1:
            maskedAnswer = leftTerm2
            questionString = String(leftTerm1) + " " + mathSymbol + " X" + " = " + String(rightTerm)
        case 2:
            maskedAnswer = rightTerm
            questionString = String(leftTerm1) + " " + mathSymbol + " " + String(leftTerm2) + " = X"
        default:
            maskedAnswer = leftTerm2
            questionString = "X " + mathSymbol + " " + String(leftTerm2) + " = " + String(rightTerm)
        }
        
        self.questionLabel.text = questionString
        
        // MARK: Make timer or not.
        if settingsDisable10 == false {
            timerCounter = 11
            
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(self.update),
                                         userInfo: nil,
                                         repeats: true)
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
        // Question label.
        questionLabel.text = ""
        
        // Message label.
        messageLabel.text = ""
        messageLabel.layer.cornerRadius = 10.0
        messageLabel.layer.borderWidth = 1.0
        messageLabel.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).cgColor
        
        // VS mode button attributes.
        vsModeButtonOutlet.layer.borderWidth = 1.0
        vsModeButtonOutlet.layer.cornerRadius = 5.0
        vsModeButtonOutlet.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
        vsModeButtonOutlet.tintColor = .white
        vsModeButtonOutlet.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        
        // Read settings in User Default.
        settingsLevel = userData.integer(forKey: "LEVEL")
        settingsBurstMode = userData.bool(forKey: "BURSTMODE")
        settingsDisable10 = userData.bool(forKey: "DISABLE10")
        settingsKukuMode = userData.bool(forKey: "99MODE")
        settingContinue = userData.bool(forKey: "CONTINUE")
        
        // Restore score and accuracy rate.
        if settingContinue {
            score = userData.integer(forKey: "SCORE")
            questionNumber = userData.integer(forKey: "QNUM")
            questionCorrect = userData.integer(forKey: "CORRECTNUM")
            
            accuracyRate = Double(questionCorrect * 100 / questionNumber)
            scoreLabel.text = "Score: " + String(score) + "(" + String(accuracyRate) + "%)"
        } else {
            scoreLabel.text = "Score: 0(0.0%)"
        }
        
        // Restore hiscore and hight accuracy rate.
        hiscore = userData.integer(forKey: "HISCORE")
        hiAccuracyRate = userData.double(forKey: "HIRATE")
        hiscoreLabel.text = "HiScore: " + String(hiscore) + "(" + String(hiAccuracyRate) + "%)"
        
        // textfield delegate.
        userAnswerTxtField.delegate = self
        
        // textfield unavailable when starting.
        userAnswerTxtField.isEnabled = false
        
        // Initialize custom keyboard.
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        keyboardView.delegate = self
        userAnswerTxtField.inputView = keyboardView
        
        // Multipeer Connectivity.
        mySession = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        mySession.delegate = self
        serviceAdvertiserAssistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: mySession)
        serviceAdvertiserAssistant.start()
        

        // Finaly, start arithmetic drill.
        nextQuestionButton(self)
    }

    
    // MARK: - MCAdvertiser.
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping(Bool, MCSession?) -> Void) {
    }
    
    // MARK: - MCBrowser.
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
    }
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
    }
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    // MARK: - MCSession.
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // 対戦中の得点のやりとりはここに
        DispatchQueue.main.async { [unowned self] in
            // "data: NSData" is recieved data.
            var dataToUInt8: UInt8 = 0
            data.copyBytes(to: &dataToUInt8, count: MemoryLayout<UInt8>.size)
            let damage = Int(dataToUInt8)
            //print("receive damage: " + String(damage))
            
            // Image effect.
            self.receiveDamageEffect()
            
            // Update score.
            self.score -= damage
            self.accuracyRate = Double(self.questionCorrect * 100 / self.questionNumber)
            self.scoreLabel.text = "Score: " + String(self.score) + "(" + String(self.accuracyRate) + "%)"
        }
    }
    // MARK: MCSession status
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            //print("Connected: \(peerID.displayName)")
            // VS mode button attributes.
            vsModeButtonOutlet.layer.borderWidth = 1.0
            vsModeButtonOutlet.layer.cornerRadius = 5.0
            vsModeButtonOutlet.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
            vsModeButtonOutlet.tintColor = .blue
            vsModeButtonOutlet.backgroundColor = .white
            
        case MCSessionState.connecting:
            //print("Connecting: \(peerID.displayName)")
            // VS mode button attributes.
            vsModeButtonOutlet.layer.borderWidth = 1.0
            vsModeButtonOutlet.layer.cornerRadius = 5.0
            vsModeButtonOutlet.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
            vsModeButtonOutlet.tintColor = .blue
            vsModeButtonOutlet.backgroundColor = .white
            
        case MCSessionState.notConnected:
            //print("Not Connected: \(peerID.displayName)")
            // VS mode button attributes.
            vsModeButtonOutlet.layer.borderWidth = 1.0
            vsModeButtonOutlet.layer.cornerRadius = 5.0
            vsModeButtonOutlet.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
            vsModeButtonOutlet.tintColor = .white
            vsModeButtonOutlet.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        }
    }
    // Received a byte stream from remote peer
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID){
        
    }
    
    // Start receiving a resource from remote peer
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress){
        
    }
    
    // Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }
    // Found a nearby advertising peer
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!){
        
    }
    
    // A nearby peer has stopped advertising
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!){
        
    }
    
    //Type 'MPCManager' does not comform to protocol 'MCNearbyServiceAdvertiserDelegate'
    // Incoming invitation request.  Call the invitationHandler block with YES and a valid session to connect the inviting peer to the session.
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession?) -> Void)!){
    }



    // MARK: - Send data via MCSession.
    func sendPoint(point: Int) {
        var p = NSInteger(point)
        let data = NSData(bytes: &p, length: MemoryLayout<NSInteger>.size)
        
        if mySession.connectedPeers.count > 0 {
            do {
                try mySession.send(data as Data, toPeers: mySession.connectedPeers, with: .reliable)
                //print("send damage point.")
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    
    // MARK: required method for keyboard delegate protocol
    func keyWasTapped(character: String) {
        userAnswerTxtField.insertText(character)
    }
    func keyDone() {
        view.endEditing(true)
    }
    func backspace() {
        userAnswerTxtField.deleteBackward()
    }


    // MARK: - didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - View will disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
        serviceAdvertiserAssistant.stop()
        
        settingsBurstMode = false
        userAnswerTxtField.isEnabled = false
        userAnswerTxtField.resignFirstResponder()
        
        if settingsBurstMode && questionNumber > 1 {
            questionNumber -= 1
            userData.set(questionNumber, forKey: "QNUM")
        }
    }


    // MARK: - 入力終了(キーボードが退場) = 答え合わせ
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        var tmpMessage: String = ""
        
        // MARK: Stop timer.
        stopTimer()
        
        // MARK: Increase number.
        questionNumber += 1
        
        // MARK: Unavailable textfield.
        userAnswerTxtField.isEnabled = false
        userAnswerTxtField.resignFirstResponder()
        
        // MARK: Get textfield value.
        let userAnswerText = textField.text! as NSString
        // Convert cast.
        userAnswer = (userAnswerText as NSString).integerValue
        
        // MARK: Check answer.
        if (self.maskedAnswer == userAnswer) {
            // Correct
            questionCorrect += 1

            if timerCounter > 0 {
                score += timerCounter
                tmpMessage = "Correct"
                sendPoint(point: timerCounter)
            }
            
            // Bonus point
            if timerCounter > 7 {
                score += 10
                tmpMessage += " and bounus point"
            }
            
            // Display image
            if settingsBurstMode == false {
                checkResultImage(result: true)

                // Play sound. If silend mode, vibrate.
                playSound(result: true)
            }
        } else {
            // Incorrect
            questionIncorrect += 1
            
            if timerCounter == 0 {
                tmpMessage = "Time up"
            } else {
                tmpMessage = "Incorrect\n" + String(maskedAnswer)
            }
            
            // Display image
            if settingsBurstMode == false && userAnswer != 0 {
                checkResultImage(result: false)
                
                // Play sound. If silend mode, vibrate.
                playSound(result: false)
            }
        }
        
        // MARK: Display message.
        messageLabel.text = tmpMessage
        
        // MARK: Overwrite score with accuracy rate
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
        if settingsBurstMode {
            nextQuestionButton(self)
        }
    }


    // MARK: - When tap return key.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userAnswerTxtField.resignFirstResponder()
        return true
    }


    // MARK: - Function which updates timer.
    @objc func update(tm: Timer) {
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
    func checkResultImage(result: Bool) {
        var fileName: String = ""
        
        if result == true {
            fileName = "Yes.png"
        } else {
            fileName = "No.png"
        }
        
        // Add image to sub view.
        let X = view.frame.width / 2 - view.frame.width * 0.65 / 2
        let Y = view.frame.height / 2 - view.frame.height * 0.65 / 2
        let rect = CGRect(x: X, y: Y, width: view.frame.width*0.65, height: view.frame.height*0.65)
        
        imageView = UIImageView(frame: rect)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: fileName)
        imageView.alpha = 0
        self.view.addSubview(imageView)

        // Animate view.
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.imageView.alpha = 1.0
            },
            completion: {(finished: Bool) in
                self.fadeOutImage(self.imageView)
        })
    }

    
    // MARK: - Image when receive damage at VS mode.
    // TODO: 上の答え合わせ結果画像と合わせてクラスにしよう。
    func receiveDamageEffect() {
        let imgFileName: String = "down.png"
        
        // Add image to sub view.
        let X = view.frame.width / 2 - view.frame.width * 0.65 / 2
        let Y = view.frame.height / 2 - view.frame.height * 0.65 / 2
        let rect = CGRect(x: X, y: Y, width: view.frame.width*0.65, height: view.frame.height*0.65)

        imageView = UIImageView(frame: rect)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: imgFileName)
        imageView.alpha = 0
        self.view.addSubview(imageView)
        
        // Animate view.
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.imageView.alpha = 1.0
            },
            completion: {(finished: Bool) in
                self.fadeOutImage(self.imageView)
        })
    }

    // MARK: - Function which remove image on screen.
    func fadeOutImage(_ view: UIView) {
        UIView.animate(
            withDuration: 1.0,
            delay: 0.5,
            options: [.curveEaseInOut],
            animations: {
                view.alpha = 0.0
            },
            completion: {(finished: Bool) in
                view.removeFromSuperview()
        })
    }


    // MARK: Function which remove image on screen.
    func removeResultImage() {
        if imageView != nil {
            imageView.removeFromSuperview()
        }
    }


    // MARK: - Function which play sound.
    func playSound(result: Bool) {
        var soundFile: NSDataAsset!
        
        if result == true {
            soundFile = NSDataAsset(name: "chime")
        } else {
            soundFile = NSDataAsset(name: "boo")
        }

        do {
            player = try AVAudioPlayer(data: soundFile.data, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
            
            // Vibration.
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
