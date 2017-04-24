//
//  QualityReport.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/30/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

public class QualityReport {
    
    private var reportNum: Int
    private var location = ""
    private var purityCondition: String
    private var address = ""
    private var date = ""
    private var virus: Double = 0.0
    private var contaminant: Double = 0.0
    private var user = ""
    let ref: FIRDatabaseReference?
    
    let years = ["2017"]
    
    public init(reportNum: Int, location: String, address: String, date: String, purityCondition: PurityCondition, virus: Double, contaminant: Double, user: String) {
        self.reportNum = reportNum
        self.location = location
        self.virus = virus
        self.contaminant = contaminant
        self.purityCondition = purityCondition.get()
        self.address = address
        self.date = date
        self.user = user
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        reportNum = snapshotValue["reportNum"] as! Int
        location = snapshotValue["location"] as! String
        address = snapshotValue["address"] as! String
        purityCondition = snapshotValue["purityCondition"] as! String
        date = snapshotValue["date"] as! String
        virus = snapshotValue["virus"] as! Double
        contaminant = snapshotValue["contaminant"] as! Double
        user = snapshotValue["user"] as! String
        ref = snapshot.ref
    }
    
    public func getAddress() -> String {
        return self.address
    }
    
    public func setAddress(address: String) {
        self.address = address
    }
    
    public func getLocation() -> String {
        return self.location
    }
    
    public func getVirusCount() -> Double {
        return self.virus
    }
    
    public func getContaminantCount() -> Double {
        return self.contaminant
    }
    
    public func getPurityCondition() -> String {
        return self.purityCondition
    }
    
    public func getReportNum() -> Int {
        return self.reportNum
    }
    
    public func getDate() -> String {
        return self.date
    }
    
    public func setLocation(location: String) {
        self.location = location
    }
    
    public func setVirusCount(virusCount: Double) {
        self.virus = virusCount
    }
    
    public func setContaminantCount(contaminantCount: Double) {
        self.contaminant = contaminantCount
    }
    
    public func setPurityCondition(purityCondition: PurityCondition) {
        self.purityCondition = purityCondition.get()
    }
    
    public func setReportNum(reportNum: Int) {
        self.reportNum = reportNum
    }
    
    public func setDate(date: String) {
        self.date = date
    }
    
    public func setUser(user: String) {
        self.user = user
    }
    
    public func getUser() -> String {
        return self.user
    }
    
    func toAnyObject() -> Any {
        return [
            "reportNum": reportNum,
            "location": location,
            "purityCondition": purityCondition,
            "address": address,
            "date": date,
            "virus": virus,
            "contaminant": contaminant,
            "user": user
        ]
    }
    
    func getYear() -> String {
        var item = ""
        for year in years {
            if (self.date.contains(year)) {
                item = year;
                break
            }
        }
        return item
    }
}
