//
//  ContactDataBase.swift
//  Contact Book
//
//  Created by Ariel Ramírez on 05/10/17.
//  Copyright © 2017 Ariel Ramírez. All rights reserved.
//

import Foundation
import SQLite3

class ContactDataBase {
    
    func connectToDB() -> OpaquePointer {
        let dbURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbPath = dbURL.appendingPathComponent("ContactBook.db")
        debugPrint("DATABASE PATH: \(dbPath.path)")
        var db: OpaquePointer?
        if sqlite3_open(dbPath.path, &db) != SQLITE_OK {
            print("error opening database")
        } else {
            print("login succes into Contacts database dude!")
        }
        return db!
    }
    
    func queryDataBase (_ queryOnDB: String) {
        let query = "SELECT * FROM Contacts where name = '\(queryOnDB)'"
        var contactsFromDataBase = [ContactPhoto]()
        let db = connectToDB()
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            var name: String = ""
            var lastName: String = ""
            var cellPhone: String = ""
            var ID: String = ""
            var imagePath: String = ""
            if let cString = sqlite3_column_text(statement, 0) {
                name = String(cString: cString)
                print("Name = \(name)")
            } else {
                print("name not found")
            }
            if let cString = sqlite3_column_text(statement, 1) {
                lastName = String(cString: cString)
                print("last name = \(lastName)")
            } else {
                print("last name not found")
            }
            if let cString = sqlite3_column_text(statement, 2) {
                cellPhone = String(cString: cString)
                print("cellPhone = \(cellPhone)")
            } else {
                print("cellPhone not found")
            }
            if let cString = sqlite3_column_text(statement, 3) {
                ID = String(cString: cString)
                print("ID = \(ID)")
            } else {
                print("ID not found")
            }
            if let cString = sqlite3_column_text(statement, 4) {
                imagePath = String(cString: cString)
                print("imagePath = \(imagePath)")
            } else {
                print("imagePath not found")
            }
            let currentContact = ContactPhoto(name, lastName, cellPhone)
            currentContact.setIDAndImagePath(ID, imagePath)
            contactsFromDataBase.append(currentContact)
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
    }
    
    func insertIntoDB (_ currentContact: ContactPhoto) {
        let db = connectToDB()
        var statement: OpaquePointer?
        let insert = "insert into Contacts values ('\(currentContact.name)', '\(currentContact.lastName)', '\(currentContact.cellPhone)','\(currentContact.ID)', '\(currentContact.imagePath)')"
        
        if sqlite3_prepare_v2(db, insert, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
    }
    
    func deleteContactWithID (_ ID: String) {
        let db = connectToDB()
        if sqlite3_exec(db, "DELETE FROM Contacts WHERE ID = '\(ID)'", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
   
}
