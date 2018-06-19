//
//  UserController .swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/18/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.


import Foundation
import CloudKit

class UserController {
    
static var shared = UserController()

var loggedInUser: User?
 
     let privateDB = CKContainer.default().privateCloudDatabase
    
    func fetchCurrentUser(completion: @escaping (Bool)->Void) {
        
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                print("error fetching user record ID. Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let appleUserRecordID = appleUserRecordID else { completion(false) ; return }
            
            let predicate = NSPredicate(format: "appleUserRef == %@", appleUserRecordID)
            
            let query = CKQuery(recordType: User.userTypeKey, predicate: predicate)
            
            self.privateDB.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error {
                    print("error fectching current user. Error\(error.localizedDescription)")
                    completion(false)
                    return
                }
                guard let records = records,
                    let loggedInUserRecord = records.first else {completion(false); return}
                
                let loggedInUser = User(ckRecord: loggedInUserRecord)
                
                self.loggedInUser = loggedInUser
                
                completion(true)
            })
        }
    }
    
    func createnewUserWith(username: String, firstname: String, lastName: String, email: String, completion: @escaping (Bool)->Void) {
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                print("there was an error fetching the curent user's apple recordID: Error: \(error.localizedDescription)\(#function)")
                completion(false)
                return
            }
            guard let appleUserRecordID = appleUserRecordID else { completion(false); return}
            
            let appleUserRef = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            
            let newUser = User(username: username, firstName: firstname, lastName: lastName, email: email, appleUserRef: appleUserRef)
            
            let record = CKRecord(user: newUser)
            
            CKContainer.default().privateCloudDatabase.save(record, completionHandler: { (_, error) in
                if let error = error {
                    print("error saving to database. Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                self.loggedInUser = newUser
                completion(true)
            })
        }
    }
}
