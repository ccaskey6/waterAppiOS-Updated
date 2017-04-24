//
//  LoginViewController.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/28/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let ref = FIRDatabase.database().reference(withPath: "users")
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    
    var invalidCount = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        FIRAuth.auth()!.signIn(withEmail: emailText.text!,
                               password: passText.text!)
        
        emailText.text = ""
        passText.text = ""
        
        self.performSegue(withIdentifier: "showAppFromLogin", sender: self)
        
//else {
//            if (invalidCount <= 0) {
//                showLockedOutAlert()
//            } else {
//                showAlert()
//                invalidCount -= 1
//            }
//        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Invalid Login Credentials", message: "\(invalidCount) attemps remaining", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func showLockedOutAlert() {
        let alert = UIAlertController(title: "You used up all your tries", message: "Try again later", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        if (emailText.text == "") {
            showNoEmailAlert()
        } else {
            var found = false
            ref.observe(.value, with: { snapshot in
                for item in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    if (item.childSnapshot(forPath: "email").value as? String == self.emailText.text!) {
                        found = true
                        break
                    }
                }
            })
            if (!found) {
                FIRAuth.auth()?.sendPasswordReset(withEmail: emailText.text!)
                
            } else {
                showUnexistingEmailAlert()
            }
            
        }
    }

    func showEmailSent() {
        let alert = UIAlertController(title: "Enter your email first", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showNoEmailAlert() {
        let alert = UIAlertController(title: "Enter your email first", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showUnexistingEmailAlert() {
        let alert = UIAlertController(title: "Email doesn't exist in the system", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
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

