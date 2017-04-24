//
//  ViewReportTableViewController.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/28/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewReportTableViewController: UITableViewController {
    
    var reports = [Report]()
    
    let ref = FIRDatabase.database().reference(withPath: "reports")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        ref.observe(.value, with: { snapshot in
            var newReports: [Report] = []
            
            for item in snapshot.children {
                let reportItem = Report(snapshot: item as! FIRDataSnapshot)
                newReports.append(reportItem)
            }
            
            self.reports = newReports
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reports.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ViewReportTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ViewReportTableViewCell else {
            fatalError("The dequeued cell is not an instance of ViewReportTableViewCell")
        }
        
        let report = reports[indexPath.row]
        
        cell.reportNumber.text = "\(indexPath.row + 1)"
        cell.locationLabel.text = report.getLocation()
        cell.waterTypeLabel.text = report.getWaterType()
        cell.waterConditionLabel.text = report.getWaterCondition()
        cell.addressLabel.text = report.getAddress()
        
        return cell
    }

    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "showSingleReportFromViewReport") {
            guard let reportDetailViewController = segue.destination as? SingleReportViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedReportCell = sender as? ViewReportTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedReportCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedReport = reports[indexPath.row]
            reportDetailViewController.report = selectedReport
        }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegue(withIdentifier: "showSingleReportFromViewReport", sender: self)
        
    }
}

