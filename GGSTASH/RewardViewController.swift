//
//  RewardViewController.swift
//  GGSTASH
//
//  Created by avnt on 2017/11/19.
//  Copyright © 2017 Wealth Sense. All rights reserved.
//

import UIKit
import FirebaseFirestore

class RewardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func claim_action(_ sender: Any) {
        // TODO reduce credit balance to 0..
        let defaultStore = Firestore.firestore()
        
        defaultStore.collection("users").document("ThREFBJE75IaZytedQme").collection("purchases").addDocument(data: [
            "credits": 10000, "productId": "mf61hHirjXn9PsjF8zBp"
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                }
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
