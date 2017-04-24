//
//  RegisterViewController.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/28/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class RegisterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // references for labels from profile
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var userTypeText: UITextField!
    
    let pickerData = [AccountType.user.get(), AccountType.worker.get(), AccountType.manager.get(),
                      AccountType.admin.get()]
    
    let userPicker = UIPickerView()
    
    let ref = FIRDatabase.database().reference(withPath: "users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        userTypeText.inputView = userPicker
        userTypeText.inputAccessoryView = toolbar
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        userTypeText.text = pickerData[row]
    }
    
    func donePicker(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    func cancelPicker(sender: UIBarButtonItem) {
        userTypeText.text = ""
        self.view.endEditing(true)
    }
    
    
    @IBAction func registerButton(_ sender: Any) {
        
        if (emailText.text! == "" || passText.text! == "" || userTypeText.text! == "") {
            showMissedTextAlert()
        } else {
            
            FIRAuth.auth()!.createUser(withEmail: emailText.text!,
                                       password: passText.text!) { user, error in
                                        if error == nil {
                                            // 3
                                            
                                            
                                            FIRAuth.auth()!.signIn(withEmail: self.emailText.text!,
                                                                   password: self.passText.text!)
                                            
                                            let newUser = User(email: self.emailText.text!, password: self.passText.text!, accountType: AccountType(rawValue: self.userTypeText.text!)!)
                                            
                                            let userItemRef = self.ref.child((user?.uid)!)
                                            
                                            userItemRef.setValue(newUser.toAnyObject())
                                            
                                            self.passText.text = ""
                                            self.emailText.text = ""
                                            self.userTypeText.text = ""
                                            
                                            self.performSegue(withIdentifier: "showLoginFromRegister", sender: self)
                                            
                                        } else {
                                            self.showSomethingWrongAlert()
                                        }
            }

        }
    }
    
    func showSomethingWrongAlert() {
        let alert = UIAlertController(title: "Something went wrong", message: "Account may be taken. Try again.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showMissedTextAlert() {
        let alert = UIAlertController(title: "One required item not filled", message: "Please complete all text boxes", preferredStyle: .alert)
        
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
