//
//  AppViewController.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/28/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AppViewController: UIViewController {
    
    let ref = FIRDatabase.database().reference(withPath: "users")
    let currentUser = FIRAuth.auth()?.currentUser
    var accountStatus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        ref.observe(.value, with: { snapshot in
            
            for item in snapshot.children.allObjects as! [FIRDataSnapshot] {
                if (self.currentUser?.email == item.childSnapshot(forPath: "email").value as? String) {
                    self.accountStatus = item.childSnapshot(forPath: "accountType").value as! String
                }
            }
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func waterQualityPressed(_ sender: Any) {
        if (accountStatus == "Worker" || accountStatus == "Manager") {
            self.performSegue(withIdentifier: "showViewWaterQualityFromApp", sender: self)
        } else {
            invalidCredentialsAlert()
        }
    }
    
    @IBAction func historicalReportPressed(_ sender: Any) {
        if (accountStatus == "Manager") {
            self.performSegue(withIdentifier: "showHistoricalReportFromApp", sender: self)
        } else {
            invalidCredentialsAlert()
        }
    }
    
    
    func invalidCredentialsAlert() {
        let alert = UIAlertController(title: "Sorry, don't have permission to view", message: "Must be manager", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }

    @IBAction func logoutTouch(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
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
