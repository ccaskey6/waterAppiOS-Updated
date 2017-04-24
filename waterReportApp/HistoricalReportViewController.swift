//
//  HistoricalReportViewController.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/30/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit
import Firebase

class HistoricalReportViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var qualityReportLocations: UITextField!
    @IBOutlet weak var plotData: UITextField!
    @IBOutlet weak var years: UITextField!
    
    var locationData = [String]()
    let plottedData = ["Virus", "Contaminant"]
    var yearData = [String]()
    
    let locationPicker = UIPickerView()
    let plotPicker = UIPickerView()
    let yearPicker = UIPickerView()
    
    let ref = FIRDatabase.database().reference(withPath: "qualityReports")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observe(.value, with: { snapshot in
            var tempLocation: [String] = []
            var tempDate: [String] = []
            
            for item in snapshot.children {
                let qualityReportItem = QualityReport(snapshot: item as! FIRDataSnapshot)
                if (!tempLocation.contains(qualityReportItem.getLocation())) {
                    tempLocation.append(qualityReportItem.getLocation())
                }
                if (!tempDate.contains(qualityReportItem.getYear())) {
                    tempDate.append(qualityReportItem.getYear())
                }
            }
            
            self.locationData = tempLocation
            self.yearData = tempDate
        })

        locationPicker.tag = 0
        plotPicker.tag = 1
        yearPicker.tag = 2
        
        locationPicker.showsSelectionIndicator = true
        locationPicker.delegate = self
        locationPicker.dataSource = self
        
        plotPicker.showsSelectionIndicator = true
        plotPicker.delegate = self
        plotPicker.dataSource = self
        
        yearPicker.showsSelectionIndicator = true
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        qualityReportLocations.inputView = locationPicker
        qualityReportLocations.inputAccessoryView = toolbar
        
        plotData.inputView = plotPicker
        plotData.inputAccessoryView = toolbar
        
        years.inputView = yearPicker
        years.inputAccessoryView = toolbar
        
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
            return locationData.count
        } else if (pickerView.tag == 1) {
            return plottedData.count
        } else {
            return yearData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            return locationData[row]
        } else if (pickerView.tag == 1) {
            return plottedData[row]
        } else {
            return yearData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0) {
            qualityReportLocations.text = locationData[row]
        } else if (pickerView.tag == 1) {
            plotData.text = plottedData[row]
        } else {
            years.text = yearData[row]
        }
    }
    
    func donePicker(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    func cancelPicker(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @IBAction func displayGraph(_ sender: Any) {
        if (qualityReportLocations.text == "" || plotData.text == "" || years.text == "") {
            showMissedTextAlert()
        } else {
            LineChartViewController.setCurrentChart(chartType: qualityReportLocations.text!)
            LineChartViewController.setChartData(data: plotData.text!)
            qualityReportLocations.text = ""
            plotData.text = ""
            years.text = ""
            self.performSegue(withIdentifier: "showGraphFromHistoricalReport", sender: self)
        }
    }
    
    
    func showMissedTextAlert() {
        let alert = UIAlertController(title: "A required item is not filled", message: "Please complete all text boxes", preferredStyle: .alert)
        
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
