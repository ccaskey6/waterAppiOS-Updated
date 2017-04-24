//
//  ProfileViewController.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/28/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var newUserTypeField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!

    
    var tempUserTypeField: String = ""
    
    let pickerData = [AccountType.user.get(), AccountType.worker.get(), AccountType.manager.get(),
                      AccountType.admin.get()]
    
    let userPicker = UIPickerView()
    
    let ref = FIRDatabase.database().reference(withPath: "users")
    let currentUser = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ref.observe(.value, with: { snapshot in
            
            for item in snapshot.children.allObjects as! [FIRDataSnapshot] {
                if (self.currentUser?.email == item.childSnapshot(forPath: "email").value as? String) {
                    self.emailLabel.text = self.currentUser?.email
                    self.newUserTypeField.text = item.childSnapshot(forPath: "accountType").value as? String
                    self.passwordLabel.text = item.childSnapshot(forPath: "password").value as? String
                }
            }
        })
        
        userPicker.showsSelectionIndicator = true
        userPicker.delegate = self
        userPicker.dataSource = self
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        newUserTypeField.inputView = userPicker
        newUserTypeField.inputAccessoryView = toolbar
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func emailButton(_ sender: Any) {
        let alert = UIAlertController(title: "Change your email below", message: "", preferredStyle: .alert)
        
        alert.addTextField { (newUsernameField) in
            newUsernameField.placeholder = "Enter new email"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (ACTION) in
            let newEmailField = alert.textFields![0] as UITextField
            if (newEmailField.text == "") {
                self.emailLabel.text = self.emailLabel.text!
            } else {
                self.emailLabel.text = newEmailField.text!
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func passwordButton(_ sender: Any) {
        let alert = UIAlertController(title: "Change your password below", message: "", preferredStyle: .alert)
        
        alert.addTextField { (newPasswordField) in
            newPasswordField.placeholder = "Enter new password"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (ACTION) in
            let newPasswordField = alert.textFields![0] as UITextField
            if (newPasswordField.text == "") {
                self.passwordLabel.text = self.passwordLabel.text!
            } else {
                self.passwordLabel.text = newPasswordField.text!
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showTakenAlert() {
        
        let alert = UIAlertController(title: "Username already taken", message: "Please try again", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func finishButton(_ sender: Any) {
        
        currentUser?.updateEmail(emailLabel.text!) { error in
            if error != nil {
                self.showTakenAlert()
            }
        }
        currentUser?.updatePassword(passwordLabel.text!)
        
        let userItemRef = self.ref.child((currentUser?.uid)!)
        
        let editedUser = User(email: emailLabel.text!, password: passwordLabel.text!, accountType: AccountType(rawValue: newUserTypeField.text!)!)
        
        userItemRef.setValue(editedUser.toAnyObject())
        
        self.performSegue(withIdentifier: "showAppFromProfile", sender: self)
    }

    
    // functions for picker views
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tempUserTypeField = pickerData[row]
    }
    
    func donePicker(sender: UIBarButtonItem) {
        newUserTypeField.text = tempUserTypeField
        self.view.endEditing(true)
    }
    
    func cancelPicker(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
        
    
    func showSomethingWentWrong() {
        let alert = UIAlertController(title: "Something went wrong", message: "Account may be taken. Try again.", preferredStyle: .alert)
        
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
