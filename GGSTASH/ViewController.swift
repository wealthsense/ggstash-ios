//
//  ViewController.swift
//  GGSTASH
//
//  Created by avnt on 2017/11/18.
//  Copyright © 2017 Wealth Sense. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Material
import EFCountingLabel
import KVNProgress

class ViewController: UIViewController {

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var currentStashLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var progressBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var chestImage: UIImageView!
    @IBOutlet weak var claimButton: UIButton!
    
    var currentCoins = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressContainerView.layer.cornerRadius = 10.0
        progressContainerView.layer.borderColor = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1).cgColor
        progressContainerView.layer.borderWidth = 4.0
        
        progressBarView.layer.cornerRadius = 5.0
    
        (progressLabel as! EFCountingLabel).format = " %d / 10000"
        (progressLabel as! EFCountingLabel).method = .easeOut
        
        (currentStashLabel as! EFCountingLabel).format = "STASH SIZE %d€"
        (currentStashLabel as! EFCountingLabel).method = .easeOut
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Coin Balance Listener
        let defaultStore = Firestore.firestore()
        
        // Stash Balance
        defaultStore.collection("users").document("ThREFBJE75IaZytedQme")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                print(document.data())
                let balance = Int(((document.data()["accountInfo"]! as! NSDictionary)["stashAccount"]! as! NSDictionary)["balance"]! as! Float)
                
                (self.currentStashLabel as! EFCountingLabel).countFrom(0, to: CGFloat(balance), withDuration: 1.0)
                print("Current data: \(balance)")
        }n
        
        defaultStore.collection("users").document("ThREFBJE75IaZytedQme")
                    .addSnapshotListener { documentSnapshot, error in
                        guard let document = documentSnapshot else {
                            print("Error fetching document: \(error!)")
                            return
                        }
                        let coins = Int(document.data()["credits"]! as! Int)
                        print("Current data: \(coins)")
                        
                        self.set_progress(old: self.currentCoins, new: coins, target: 10000)
                        self.currentCoins = coins
                }
        
        // Stash Balance Listener
//        defaultStore.collection("transfers").document("urGipzjI24aWanD2wDSM")
//            .addSnapshotListener { documentSnapshot, error in
//                guard let document = documentSnapshot else {
//                    print("Error fetching document: \(error!)")
//                    return
//                }
//                print("Current data: \(document.data())")
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addToStashAction(_ sender: Any) {

    }
    
    @IBAction func claim_reward_action(_ sender: Any) {
        
        // TODO reduce credit balance to 0..
//        let defaultStore = Firestore.firestore()
//
//        defaultStore.collection("users").document("ThREFBJE75IaZytedQme").updateData([
//            "credits": 0
//        ]) { err in
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
    }
    
    func set_progress(old: Int, new: Int, target: Int) {
        view.layoutIfNeeded()
        
        (progressLabel as! EFCountingLabel).countFrom(CGFloat(old), to: CGFloat(new), withDuration: 3.0)

        progressBarConstraint.constant = min(CGFloat((Float(new) / Float(target)) * 228.0), 228.0)
        
        if (Float(new) / Float(target) <= 0.3) {
            self.statusLabel.text = "PATIENCE!"
        } else if (Float(new) / Float(target) <= 0.99) {
            self.statusLabel.text = "ALMOST THERE!"
        } else {
            self.statusLabel.text = "GET YOUR REWARD!"
        }
        
        // Check for unlock
        if (new >= target) {
            //        set_progress(old: 2344, new: 9000, target: 10000)
            
                    chestImage.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                    lockImage.alpha = 0
                    claimButton.isEnabled = true
            
                    UIView.animate(withDuration: 1.0,
                                   delay: 0.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 3.0,
                                   options: [.allowUserInteraction, .repeat, .autoreverse],
                                   animations: {
                                    self.chestImage.transform = CGAffineTransform.identity
                    }, completion: nil)
        } else {
            lockImage.alpha = 1
            claimButton.isEnabled = false
            
            self.chestImage.layer.removeAllAnimations()
        }
        
        UIView.animate(withDuration: 3.0, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

