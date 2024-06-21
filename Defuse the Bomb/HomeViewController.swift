//
//  HomeViewController.swift
//  Defuse the Bomb
//
//  Created by ISYS Macbook air 1 on 13/06/24.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet var playBtn: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        print("Hello first page")
        let taptap = UITapGestureRecognizer(target: self, action: #selector(playButtonPressed))
        playBtn.isUserInteractionEnabled = true
        playBtn.addGestureRecognizer(taptap)
        // Do any additional setup after loading the view.
    }
    
    @objc func playButtonPressed(){
//        print("Clicked")
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "bombview") as? ViewController {
//            navigationController?.pushViewController(vc, animated: true)
//        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "roleView") as! RoleViewController
        navigationController?.pushViewController(vc, animated: true)
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
