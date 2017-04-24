//
//  Report.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/28/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

public class Report {
    
    private var reportNum: Int
    private var location = ""
    private var waterType: String
    private var waterCondition: String
    private var address = ""
    let ref: FIRDatabaseReference?
    
    public init(reportNum: Int, location: String, address: String, waterType: WaterType, waterCondition: WaterCondition) {
        self.reportNum = reportNum
        self.location = location
        self.waterType = waterType.get()
        self.waterCondition = waterCondition.get()
        self.address = address
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        reportNum = snapshotValue["reportNum"] as! Int
        location = snapshotValue["location"] as! String
        address = snapshotValue["address"] as! String
        waterType = snapshotValue["waterType"] as! String
        waterCondition = snapshotValue["waterCondition"] as! String
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
    
    public func getWaterType() -> String {
        return self.waterType
    }
    
    public func getWaterCondition() -> String {
        return self.waterCondition
    }
    
    public func getReportNum() -> Int {
        return self.reportNum
    }
    
    public func setLocation(location: String) {
        self.location = location
    }
    
    public func setWaterType(waterType: WaterType) {
        self.waterType = waterType.get()
    }
    
    public func setWaterCondition(waterCondition: WaterCondition) {
        self.waterCondition = waterCondition.get()
    }
    
    public func setReportNum(reportNum: Int) {
        self.reportNum = reportNum
    }
    
        public func toString() -> String {
            return "\(waterType)" + ": " + "\(waterCondition)"
        }
    
    func toAnyObject() -> Any {
        return [
            "reportNum": reportNum,
            "location": location,
            "waterType": waterType,
            "waterCondition": waterCondition,
            "address": address
        ]
    }
}
