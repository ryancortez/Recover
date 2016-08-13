////
////  CloudKitManager.swift
////  Lists
////
////  Created by Ryan Cortez on 8/10/16.
////  Copyright © 2016 Ryan Cortez. All rights reserved.
////
//
//import Foundation
//import CloudKit
//import UIKit
//
//class CloudKitManager: NSObject {
//
//    // MARK: - Global Variables
//    var container :CKContainer!
//    var privateDB :CKDatabase!
//    var lists: Array<List> = []
//    
//    // MARK: - String Contstants
//    let listRecordType = "List"
//    let titleFieldName = "listFieldName"
//    let itemsFieldName = "itemsFieldName"
//    
//    // MARK: - Init Methods
//    override init() {
//        super.init()
//        // Set up a public and private database for CloudKit
//        self.container = CKContainer.defaultContainer()
//        self.privateDB = self.container.privateCloudDatabase
//    }
//    
//    // MARK: - Fetching Data
//    func fetchAllLists() {
//        
//        let listRecordType = "List"
//        let titleFieldName = "listFieldName"
//        let itemsFieldName = "itemsFieldName"
//        
//        let query = CKQuery(recordType: listRecordType, predicate: NSPredicate(value: true))
//        query.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
//        self.privateDB.performQuery(query, inZoneWithID: nil) { (cloudKitRecords :[CKRecord]?, error :NSError?) in
//            
//            guard let records = cloudKitRecords else {
//                print("Did not find any records in CloudKit"); return
//            }
//            
//            for record in records {
//                guard let listTitle = record.valueForKey(titleFieldName) as? String else {
//                    print("Did not find List title in CKRecord with key: \(titleFieldName)")
//                    return
//                }
//                guard let listItems = record.valueForKey(itemsFieldName) as? NSMutableArray else {
//                    print("Did not find Array<ListItems> in CKRecord with key: \(itemsFieldName)")
//                    return
//                }
//                
//                let list = List(title: listTitle, andListItems: listItems)
//                self.lists.append(list)
//                
//
//                if ((error) != nil) {
//                    print("Did not get all Lists from CloudKit due to error: \(error)")
//                }
//            }
//        }
//    }
//}
//
