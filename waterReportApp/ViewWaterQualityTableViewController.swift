//
//  ViewWaterQualityTableViewController.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/30/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class ViewWaterQualityTableViewController: UITableViewController {

    var qualityReports = [QualityReport]()
    
    let ref = FIRDatabase.database().reference(withPath: "qualityReports")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref.observe(.value, with: { snapshot in
            var newQualityReports: [QualityReport] = []
            
            for item in snapshot.children {
                let qualityReportItem = QualityReport(snapshot: item as! FIRDataSnapshot)
                newQualityReports.append(qualityReportItem)
            }
            
            self.qualityReports = newQualityReports
            self.tableView.reloadData()
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return qualityReports.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ViewQualityReportTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ViewQualityReportTableViewCell else {
            fatalError("The dequeued cell is not an instance of ViewQualityReportTableViewCell")
        }

        let qualityReport = qualityReports[indexPath.row]
        
        cell.reportNumber.text = "\(indexPath.row + 1)"
        cell.location.text = qualityReport.getLocation()
        cell.dateTimestamp.text = qualityReport.getDate()
        cell.workerName.text = qualityReport.getUser()
        cell.address.text = qualityReport.getAddress()
        cell.condition.text = qualityReport.getPurityCondition()
        cell.virusPPM.text = String(qualityReport.getVirusCount())
        cell.contaminantPPM.text = String(qualityReport.getContaminantCount())
        
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //let cell = tableView.cellForRow(at: indexPath as IndexPath)
        
        //tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        self.performSegue(withIdentifier: "showEditQualityReportFromTable", sender: self)
        
        //        let row = indexPath.row
        //        print(swiftBlogs[row])
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "showEditQualityReportFromTable") {
            guard let qualityReportDetailViewController = segue.destination as? SingleQualityReportViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedReportCell = sender as? ViewQualityReportTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedReportCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedQualityReport = qualityReports[indexPath.row]
            qualityReportDetailViewController.qualityReport = selectedQualityReport
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
