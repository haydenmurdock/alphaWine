//
//  User.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/18/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import Foundation
import CloudKit

class User {
    static let userTypeKey = "User"
    static let usernameKey = "username"
    static let firstNameKey = "firstName"
    static let lastNamekey = "lastName"
    static let email = "email"
    static let appleUserRefKey = "appleUserRef"
    let username: String
    let firstName: String
    let lastName: String
    let email: String
    
    var cloudKitRecordID: CKRecordID?
    let appleUserRef: CKReference
    
    init(username: String, firstName: String, lastName: String, email: String, appleUserRef: CKReference) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.appleUserRef = appleUserRef
        
    }
    
    init?(ckRecord: CKRecord){
        guard let username = ckRecord[User.usernameKey] as? String,
            let firstName = ckRecord[User.firstNameKey] as? String,
            let lastName = ckRecord[User.lastNamekey] as? String,
            let email = ckRecord[User.email] as? String,
            let appleUserRef = ckRecord[User.appleUserRefKey] as? CKReference else {return nil}
        
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.appleUserRef = appleUserRef
        self.email = email
        self.cloudKitRecordID = ckRecord.recordID
        
    }
}

extension CKRecord {
    convenience init(user: User){
        let recordID = user.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: User.userTypeKey, recordID: recordID)
        self.setValue(user.username, forKey: User.usernameKey)
        self.setValue(user.firstName, forKey: User.firstNameKey)
        self.setValue(user.lastName, forKey: User.lastNamekey)
        self.setValue(user.email, forKey: User.email)
        self.setValue(user.appleUserRef, forKey: User.appleUserRefKey)
        
        user.cloudKitRecordID = recordID
    }
}

