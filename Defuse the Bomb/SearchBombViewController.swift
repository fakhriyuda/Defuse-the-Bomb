//
//  SearchBombViewController.swift
//  Defuse the Bomb
//
//  Created by ISYS Macbook air 1 on 06/06/24.
//

import UIKit
import CoreLocation
import Lottie


class SearchBombViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet var meterLabel: UILabel!
    var locationManager: CLLocationManager?
    var bombDetected = false
    private var animationView : LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.topViewController = hide
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        animationView = .init(name: "radar")
        animationView?.frame = view.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode =  .loop
        animationView?.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView?.play()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    if !bombDetected {
                        startScanning()
                    }
                    
                }
            }
        }
    }
    
    func startScanning(){
        print("START SCANNING")
        let uuid = UUID(uuidString: "DEB9423A-08EE-4FB7-994A-8774C330908A")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456,identifier: "Bomb")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
    }
    
    func update(distance : CLProximity,  accuracy: CLLocationAccuracy){
        if accuracy < 0.0 {
            meterLabel.text = "Too far"
        }else{
            meterLabel.text = "\(String(format: "%.2f", accuracy)) meters"
        }
        
        switch accuracy {
        case ..<0.0:
            distanceLabel.text = "Where's the Bomb"
            self.view.backgroundColor = .lightGray
            animationView?.animationSpeed = 0.5
        case 0.0..<0.5:
            distanceLabel.text = "Heres the bomb"
            self.view.backgroundColor = .red
            animationView?.animationSpeed = 1.0
            bombDefusing()
        case 0.5..<3:
            distanceLabel.text = "Near"
            self.view.backgroundColor = .orange
            animationView?.animationSpeed = 0.8
            
        case 3..<50:
            distanceLabel.text = "Far"
            self.view.backgroundColor = .red
            animationView?.animationSpeed = 0.5
            
        default:
            distanceLabel.text = "So Far Away"
            self.view.backgroundColor = .lightGray
            animationView?.animationSpeed = 0.5
        }
    }
    
    func bombDefusing(){
        // Navigate to Defuse bomb
        if !bombDetected {
            locationManager?.stopUpdatingLocation()
            navigationController?.popViewController(animated: true)
        }
        bombDetected = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first{
            // Get the proximity and accuracy
            let accuracy = beacon.accuracy
            
            // Print proximity and distance
            print("Accuracy: \(accuracy) meters")
            update(distance: beacon.proximity,accuracy: accuracy)
        }else{
            update(distance: .unknown,accuracy: 0)
        }
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
