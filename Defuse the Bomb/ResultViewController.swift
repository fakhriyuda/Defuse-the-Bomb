//
//  ResultViewController.swift
//  Defuse the Bomb
//
//  Created by ISYS Macbook air 1 on 19/06/24.
//

import UIKit
import Lottie


class ResultViewController: UIViewController {
    
    var gameWin : Bool?
    
    
    @IBOutlet var confView: UIView!
    @IBOutlet var resultGame: UIImageView!
    var confetti : LottieAnimationView?
    var resultLottie : LottieAnimationView?
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var resultGameAnimation: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clear any existing Lottie animation views
        resultGameAnimation.subviews.forEach { $0.removeFromSuperview() }
        if gameWin == true {
            confetti = .init(name: "confetti")
            confetti?.frame = view.bounds
            confetti?.contentMode = .scaleAspectFit
            confetti?.loopMode = .playOnce
            confetti?.animationSpeed = 1
            confView.addSubview(confetti!)
            confetti?.play()
            resultLottie = .init(name: "winner")
        }else{
            resultLottie = .init(name: "hang")
        }
        resultLottie?.contentMode = .scaleAspectFit
        resultLottie?.translatesAutoresizingMaskIntoConstraints = false
        resultLottie?.loopMode = .loop
        resultLottie?.animationSpeed = 0.5
        resultGameAnimation.addSubview(resultLottie!)
        
        NSLayoutConstraint.activate([
            resultLottie!.centerXAnchor.constraint(equalTo: resultGameAnimation.centerXAnchor),
            resultLottie!.centerYAnchor.constraint(equalTo: resultGameAnimation.centerYAnchor),
            resultLottie!.widthAnchor.constraint(equalTo: resultGameAnimation.widthAnchor),
            resultLottie!.heightAnchor.constraint(equalTo: resultGameAnimation.heightAnchor),
        ])
        resultLottie?.play()
        playBtn.setTitle("", for: .normal)
        playBtn.setImage(UIImage(named: "playagain")?.withRenderingMode(.alwaysOriginal), for: .normal)
        if gameWin == true {
            resultGame.image = UIImage(named: "defused")?.withRenderingMode(.alwaysOriginal)
        }else{
            resultGame.image = UIImage(named: "lose")?.withRenderingMode(.alwaysOriginal)
        }
        
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(playAgain))
        playBtn.addGestureRecognizer(gestureTap)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func playAgain(){
        UIView.animate(withDuration: 0.1, animations:{ [self] in
            self.playBtn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }){_ in
            self.playBtn.transform = CGAffineTransform.identity
        }
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
