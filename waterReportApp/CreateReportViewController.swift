//
//  CreateReportViewController.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/28/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import Firebase
import FirebaseDatabase

class CreateReportViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var placesClient: GMSPlacesClient!
    //var locationManager = CLLocationManager()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var waterTypeText: UITextField!
    @IBOutlet weak var waterConditionText: UITextField!

    let waterTypeData = [WaterType.bottled.get(), WaterType.well.get(), WaterType.stream.get(), WaterType.lake.get(), WaterType.spring.get(), WaterType.other.get()]
    
    let waterConditionData = [WaterCondition.waste.get(), WaterCondition.treatable_clear.get(), WaterCondition.treatable_muddy.get(), WaterCondition.potable.get()]
    
    let waterTypePicker = UIPickerView()
    let waterConditionPicker = UIPickerView()
    
    let ref = FIRDatabase.database().reference(withPath: "reports")
    var reportNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observe(.value, with: { snapshot in
            for _ in snapshot.children {
                self.reportNum += 1
            }
        })
        
        placesClient = GMSPlacesClient.shared()
        
        waterTypePicker.tag = 0
        waterConditionPicker.tag = 1
        
        
        waterTypePicker.showsSelectionIndicator = true
        waterTypePicker.delegate = self
        waterTypePicker.dataSource = self
        
        waterConditionPicker.showsSelectionIndicator = true
        waterConditionPicker.delegate = self
        waterConditionPicker.dataSource = self
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        waterTypeText.inputView = waterTypePicker
        waterTypeText.inputAccessoryView = toolbar
        
        waterConditionText.inputView = waterConditionPicker
        waterConditionText.inputAccessoryView = toolbar
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
        if (pickerView.tag == 0) {
            return waterTypeData.count
        } else {
            return waterConditionData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            return waterTypeData[row]
        } else {
            return waterConditionData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0) {
            waterTypeText.text = waterTypeData[row]
        } else {
            waterConditionText.text = waterConditionData[row]
        }
    }
    
    func donePicker(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    func cancelPicker(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @IBAction func submitCreatedReport(_ sender: Any) {
        let newReport = Report(reportNum: reportNum + 1, location: nameLabel.text!, address: addressLabel.text!, waterType: WaterType(rawValue: waterTypeText.text!)!, waterCondition: WaterCondition(rawValue: waterConditionText.text!)!)
        
        if (waterTypeText.text == "" || waterConditionText.text == "" || nameLabel.text == "Name" || nameLabel.text == "No place selected") {
            showMissedTextAlert()
        } else {
            nameLabel.text = "Name"
            addressLabel.text = "Address"
            waterTypeText.text = ""
            waterConditionText.text = ""
            
            let reportItemRef = self.ref.child("\(newReport.getReportNum())")
            
            reportItemRef.setValue(newReport.toAnyObject())
            
            self.performSegue(withIdentifier: "showViewReportFromCreate", sender: self)
        }
    }
    
    func showMissedTextAlert() {
        let alert = UIAlertController(title: "A required item is not filled", message: "Please complete all text boxes", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//    func showAlreadyTakenAlert() {
//        let alert = UIAlertController(title: "Sorry, report already made", message: "Please try again", preferredStyle: .alert)
//        
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        
//        alert.addAction(action)
//        
//        present(alert, animated: true, completion: nil)
//        
//    }
    
    @IBAction func pickPlace(_ sender: UIButton) {
        
        let center = CLLocationCoordinate2D(latitude: 33.7756, longitude: -84.3963)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                self.nameLabel.text = place.name
                self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                    .joined(separator: "\n")
            } else {
                self.nameLabel.text = "No place selected"
                self.addressLabel.text = ""
            }
        })
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
