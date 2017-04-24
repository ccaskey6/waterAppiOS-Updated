//
//  WaterQualityViewController.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/30/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CreateWaterQualityViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var placesClient: GMSPlacesClient!

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var contaminantPPM: UITextField!
    @IBOutlet weak var virusPPM: UITextField!
    @IBOutlet weak var purityCondition: UITextField!
    
    var currentDate = NSDate()
    let dateFormatter = DateFormatter()
    var convertedDate = ""
    
    let purityConditionData = [PurityCondition.safe.get(), PurityCondition.treatable.get(), PurityCondition.unsafe.get()]
    
    let purityConditionPicker = UIPickerView()
    
    let ref = FIRDatabase.database().reference(withPath: "qualityReports")
    let currentUser = FIRAuth.auth()?.currentUser
    
    var qualityReportNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observe(.value, with: { snapshot in
            for _ in snapshot.children {
                self.qualityReportNum += 1
            }
        })
        
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        convertedDate = dateFormatter.string(from: currentDate as Date)
        
        placesClient = GMSPlacesClient.shared()

        purityConditionPicker.showsSelectionIndicator = true
        purityConditionPicker.delegate = self
        purityConditionPicker.dataSource = self

        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        purityCondition.inputView = purityConditionPicker
        purityCondition.inputAccessoryView = toolbar
        
        
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
        return purityConditionData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return purityConditionData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        purityCondition.text = purityConditionData[row]
    }
    
    func donePicker(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    func cancelPicker(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }


    @IBAction func pickLocation(_ sender: Any) {
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
                self.location.text = place.name
                self.address.text = place.formattedAddress?.components(separatedBy: ", ")
                    .joined(separator: "\n")
            } else {
                self.location.text = "No place selected"
                self.address.text = ""
            }
        })
    }
    
    @IBAction func submitQualityReport(_ sender: Any) {
        let newQualityReport = QualityReport(reportNum: qualityReportNum + 1, location: location.text!, address: address.text!, date: convertedDate, purityCondition: PurityCondition(rawValue: purityCondition.text!)!, virus: Double(virusPPM.text!)!, contaminant: Double(contaminantPPM.text!)!, user: (currentUser?.email)!)
        
        if (purityCondition.text == "" || virusPPM.text == "" || contaminantPPM.text == "" || location.text == "Name" || location.text == "No place selected") {
            showMissedTextAlert()
        } else {
            location.text = "Name"
            address.text = "Address"
            virusPPM.text = ""
            contaminantPPM.text = ""
            purityCondition.text = ""
            
            let qualityReportItemRef = self.ref.child("\(newQualityReport.getReportNum())")
            qualityReportItemRef.setValue(newQualityReport.toAnyObject())
            
            self.performSegue(withIdentifier: "showQualityListFromSingleQualityReport", sender: self)
        }
    }
    
    
    func showMissedTextAlert() {
        let alert = UIAlertController(title: "A required item is not filled", message: "Please complete all text boxes", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func showAlreadyTakenAlert() {
        let alert = UIAlertController(title: "Sorry, report already made", message: "Please try again", preferredStyle: .alert)
        
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
