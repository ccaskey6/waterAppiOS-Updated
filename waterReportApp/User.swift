//
//  User.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/28/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

public class User {
    
    private var password = ""
    private var accountType: String
    private var email = ""
    let ref: FIRDatabaseReference?
    
    public init(email: String, password: String, accountType: AccountType) {
        self.email = email
        self.password = password
        self.accountType = accountType.get()
        self.ref = nil
    }
    
    public func getPassword() -> String {
        return self.password
    }
    
    public func getEmail() -> String {
        return self.email
    }
    
    public func getAccountType() -> String {
        return self.accountType
    }
    
    public func setPassword(password: String) {
        self.password = password
    }
    
    public func setEmail(email: String) {
        self.email = email
    }
    
    public func setAccountType(accountType: AccountType) {
        self.accountType = accountType.get()
    }
    
    public func toString() -> String {
        return "\(accountType)" + ": " + "\(email)"
    }
    
    func toAnyObject() -> Any {
        return [
            "email": email,
            "password": password,
            "accountType": accountType
        ]
    }
    
}
