//
//  BombViewController.swift
//  Defuse the Bomb
//
//  Created by ISYS Macbook air 1 on 20/06/24.
//

import UIKit
import CoreBluetooth
import CoreLocation

class BombViewController: UIViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var blinker: UIImageView!
    var localBeacon : CLBeaconRegion!
    var beaconPeripheralData : NSDictionary!
    var peripheralManager : CBPeripheralManager!
    let localBeaconUUID = "DEB9423A-08EE-4FB7-994A-8774C330908A"
    let localBeaconMajor : CLBeaconMajorValue = 123
    let localBeaconMinor : CLBeaconMinorValue = 456
    let identifier = "Bomb"
    
    // Initialize the images
    let timerOff = UIImage(named: "timer")
    let timerOn = UIImage(named: "timer-on")
    
    // Timer for image toggling
    var imageToggleTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocalBeacon()
    }
    
    func initLocalBeacon(){
        if localBeacon != nil{
            stopLocalBeacon()
            imageToggleTimer?.invalidate()
        }
        let uuid = UUID(uuidString: localBeaconUUID)!
        localBeacon = CLBeaconRegion(uuid: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: identifier)
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil,options: nil)
        imageToggleTimer =  Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(blinkBomb), userInfo: nil, repeats: true)
    }
    
    @objc func blinkBomb(){
        if blinker.image == timerOn {
            blinker.image = timerOff
        }else{
            blinker.image = timerOn
        }
    }
    
    func stopLocalBeacon(){
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as? [String : Any])
        }else{
            peripheralManager.stopAdvertising()
        }
    }
    
    deinit {
        imageToggleTimer?.invalidate()
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
