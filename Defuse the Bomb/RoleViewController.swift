//
//  RoleViewController.swift
//  Defuse the Bomb
//
//  Created by ISYS Macbook air 1 on 20/06/24.
//

import UIKit

class RoleViewController: UIViewController {
    @IBOutlet weak var policeBtn: UIButton!
    @IBOutlet weak var badBtn: UIButton!
    @IBOutlet weak var chooseBtn: UIButton!
    
    var selectedRole = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        policeBtn.setImage(UIImage(named: "pick2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        badBtn.setImage(UIImage(named: "pick1")?.withRenderingMode(.alwaysOriginal), for: .normal)
        chooseBtn.setImage(UIImage(named: "choose")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        policeBtn.setTitle("", for: .normal)
        badBtn.setTitle("", for: .normal)
        badBtn.alpha = 0.5
        
        policeBtn.tag = 0
        badBtn.tag = 1
        chooseBtn.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func choosePressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations:{
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }){_ in
            sender.transform = CGAffineTransform.identity
            print("i clicked on tag : \(sender.tag)")
            if self.selectedRole == 0 {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "bombview") as? ViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "bomberView") as? BombViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    @IBAction func playerPicked(_ sender: UIButton) {
        clearBorders()
       
        sender.alpha = 1
        selectedRole = sender.tag
    }
    
    func clearBorders() {
        policeBtn.alpha = 0.5
        badBtn.alpha = 0.5
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
