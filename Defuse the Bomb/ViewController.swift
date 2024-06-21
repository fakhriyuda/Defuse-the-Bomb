//
//  ViewController.swift
//  Defuse the Bomb
//
//  Created by ISYS Macbook air 1 on 05/06/24.
//

import UIKit
import AVFoundation
import CoreLocation


class ViewController: UIViewController {
    @IBOutlet var bubbleView: UIView!
    @IBOutlet var bubbleLabel: UILabel!
    @IBOutlet var continueBtn: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    var buttonNormal : UIImage?
    var buttonPressed : UIImage?
    var audioPlayer : AVAudioPlayer?
    var backgroundPlayer : AVAudioPlayer?
    
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    var countDownTimer : Timer?
    var totalTime = 181
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btnDef: UIImageView!
    
    var patternToMatch : [UIButton] = []
    var userClickedButtons : [UIButton] = []
    var buttons : [UIButton] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        //        loadSound(named: "click")
        setupUI()
        
        let tutorialText = "Hey brotherrr!! You have to memorize a pattern to defuse the bomb. The bomb will explode in 3 minute!!! if you fail, u will DIE. \n\nSEARCH THE BOMB!!!"
        loadSound(named: "typing")
        typeText(tutorialText, in: bubbleLabel)
        
        setKeypad()
        
        
        btnDef.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(defusePressed))
        btnDef.addGestureRecognizer(tapGesture)
        
        
        patternToMatch = generateRandomPattern()
        
    }
    
    
    
    func startPattern(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.simulatePattern()
        }
    }
    
    // Function to generate a random pattern
    func generateRandomPattern() -> [UIButton] {
        var shuffledButtons = buttons
        shuffledButtons.shuffle() // Shuffle the array of buttons
        
        // Determine the number of buttons in the pattern (e.g., choose 3 buttons randomly)
        let patternLength = 5 // Adjust this as per your game's requirements
        let randomPattern = Array(shuffledButtons.prefix(patternLength))
        
        print("randomPattern : \(randomPattern)")
        
        return randomPattern
    }
    
    func simulatePattern(){
        loadSound(named: "click")
        for (index, button) in self.patternToMatch.enumerated(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 * Double(index)){
                self.animateButtonPress(button)
            }
        }
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.5 * Double(self.patternToMatch.count)){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "searchBomb") as? SearchBombViewController
            
            self.startTimer()
            
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func animateButtonPress(_ button : UIButton){
        UIView.animate(withDuration: 0.3,animations: {button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            button.setImage(self.buttonPressed, for: .normal)
        }){_ in
            UIView.animate(withDuration: 0.3){
                button.transform = CGAffineTransform.identity
                button.setImage(self.buttonNormal, for: .normal)
            }}
        
        if let player = self.audioPlayer{
            if player.isPlaying{
                player.stop()
                player.currentTime = 0
            }
            player.play()
        }
        
        
        
    }
    
    func setupUI(){
        continueBtn.alpha = 0
        continueBtn.titleLabel?.font = UIFont(name: "Menlo", size: 17)
        
        bubbleView.backgroundColor = .systemGray5
        bubbleView.layer.cornerRadius = 16
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.layer.borderColor = UIColor.black.cgColor
        bubbleView.layer.borderWidth = 2
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsHorizontalScrollIndicator = false
        bubbleLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleLabel.numberOfLines = 0
        bubbleLabel.lineBreakMode = .byWordWrapping
        
        NSLayoutConstraint.activate([
            bubbleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor,constant: -10),
            
            bubbleView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3){
            self.bubbleView.alpha = 0
            self.startPattern()
        }
    }
    func typeText(_ text : String, in label : UILabel){
        label.text = ""
        var characterIndex = 0.0
        self.audioPlayer?.play()
        for (index,character) in text.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05 * characterIndex){
                label.text?.append(character)
                self.updateScrollViewContentSize()
                // Stop the sound after the last character is appended
                if (index == text.count - 1) {
                    self.audioPlayer?.stop()
                    self.continueBtn.alpha = 1
                }
            }
            characterIndex += 1
        }
        
    }
    
    func updateScrollViewContentSize(){
        bubbleLabel.sizeToFit()
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: bubbleLabel.frame.height)
        scrollToBottom()
    }
    
    func scrollToBottom() {
        let bottomOffSet = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height)
        if bottomOffSet.y > 0 {
            scrollView.setContentOffset(bottomOffSet, animated: true)
        }
    }
    
    func setKeypad()  {
        
        buttons = [btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9]
        
        buttonNormal = UIImage(named: "buttonb")?.withRenderingMode(.alwaysOriginal)
        buttonPressed = UIImage(named: "buttonbp")?.withRenderingMode(.alwaysOriginal)
        
        
        
        for button in buttons {
            button.setImage(buttonNormal,for: .normal)
            button.setTitle("", for: .normal)
            button.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
            button.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside,.touchUpOutside,.touchCancel])
        }
    }
    
    func startTimer(){
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        loadBackground(named: "backgroundmusic")
        backgroundPlayer?.play()
    }
    
    @objc func updateTime(){
        if totalTime>0 {
            totalTime -= 1
            countDownLabel.text =  timeString(time: TimeInterval(totalTime))
            
        }else{
            resetTimer()
            countDownLabel.text = "BOOM!!!"
            
            backgroundPlayer?.stop()
            loadBackground(named: "bomb")
            backgroundPlayer?.play()
            let vc = storyboard?.instantiateViewController(withIdentifier: "resultView") as! ResultViewController
            vc.gameWin = false
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func resetTimer(){
        countDownTimer?.invalidate()
        countDownTimer = nil
        totalTime = 16
    }
    
    func timeString(time: TimeInterval)-> String{
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d : %02d", minutes,seconds)
    }
    @objc func buttonTouchDown(sender: UIButton){
        UIView.animate(withDuration: 0.1, animations: { [self] in
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            if let player = audioPlayer{
                if player.isPlaying{
                    player.stop()
                    player.currentTime = 0
                }
                player.play()
            }
        })
    }
    
    @objc func buttonTouchUp(sender: UIButton){
        
        UIView.animate(withDuration: 0.3, animations: { [self] in
            sender.transform = CGAffineTransform.identity
            if sender.currentImage == buttonNormal{
                print("Jadi pressed")
                sender.setImage(buttonPressed, for: .normal)
                userClickedButtons.append(sender)
            }else{
                print("Jadi normal")
                sender.setImage(buttonNormal, for: .normal)
                if let index = userClickedButtons.firstIndex(of: sender){
                    userClickedButtons.remove(at: index)
                }
            }
            
            
        })
    }
    
    @objc func defusePressed(_ sender: UITapGestureRecognizer){
        let vc = storyboard?.instantiateViewController(withIdentifier: "resultView") as! ResultViewController
        UIView.animate(withDuration: 0.1, animations: { [self] in
            self.btnDef.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            if let player = audioPlayer{
                if player.isPlaying{
                    player.stop()
                    player.currentTime = 0
                }
                player.play()
            }
            countDownTimer?.invalidate()
            if checkInputMatch() {
                print("DEFUSED")
                backgroundPlayer?.stop()
                loadBackground(named: "win")
                vc.gameWin = true
            }else{
                print("BOOM!!!!")
                loadBackground(named: "lose")
                vc.gameWin = false
            }
            backgroundPlayer?.play()
        }){_ in
            self.btnDef.transform = CGAffineTransform.identity
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    func checkInputMatch() -> Bool{
        
        if patternToMatch.count != userClickedButtons.count {
            return false
        }
        for (btn1, btn2) in zip(patternToMatch, userClickedButtons) {
            if btn1 != btn2 {
                return false
            }
        }
        return true
    }
    
    func loadSound(named fileName: String){
        if let soundUrl = Bundle.main.url(forResource: fileName, withExtension: "mp3"){
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Audio doesn't exist")
            }
        }
    }
    func loadBackground(named fileName: String){
        if let backsoundUrl = Bundle.main.url(forResource: fileName, withExtension: "mp3"){
            do {
                backgroundPlayer = try AVAudioPlayer(contentsOf: backsoundUrl)
                if fileName == "backgroundmusic"{
                    backgroundPlayer?.numberOfLoops = -1
                }else{
                    backgroundPlayer?.numberOfLoops = 0
                }
                backgroundPlayer?.prepareToPlay()
            } catch {
                print("Audio doesn't exist")
            }
        }
    }
    
    
}

