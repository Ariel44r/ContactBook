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
            if let cString = sqlite3_column_text(statement, 0) {
                let name = String(cString: cString)
                print("Name = \(name)")
            } else {
                print("name not found")
            }
            
            if let cString = sqlite3_column_text(statement, 0) {
                let lastName = String(cString: cString)
                print("last name = \(lastName)")
            } else {
                print("name not found")
            }
            
            if let cString = sqlite3_column_text(statement, 1) {
                let ID = String(cString: cString)
                print("ID = \(ID)")
            } else {
                print("name not found")
            }
            
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
    }
    
    func insertIntoDB () {
        let db = connectToDB()
        var statement: OpaquePointer?
        let insert = "insert into Contacts values ('Maximiliano', 'Ramirez', '0000000000','2', '/PATH/')"
        
        if sqlite3_prepare_v2(db, insert, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
    }
}
