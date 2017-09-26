//
//  Contact.swift
//  Contact Book
//
//  Created by Ariel Ramírez on 23/09/17.
//  Copyright © 2017 Ariel Ramírez. All rights reserved.
//

import Foundation
import UIKit

class Contact {

    let processingQueue = OperationQueue()
    
    var contactPhotos = [ContactPhoto]()
    
    func receiveContactsAndAdd(contact:ContactPhoto) {
        
        contactPhotos.append(contact)
        
    }
    
    func searchContactForTerm(_ searchTerm: String, index: Int, completion : @escaping (_ results: ContactSearchResults?, _ error: Error?) -> Void) {
        
        print("Search Term typed is: \(searchTerm)")
        
        //Add actions to find Contact for searchTerm
        
        print("PATH: \(getPath())")
        
        
        for index in 0 ..< contactPhotos.count {
            
            contactPhotos[index].photoTumbnail = #imageLiteral(resourceName: "contact")
            //find term String by String
            
        }
        
        OperationQueue.main.addOperation({
            completion(ContactSearchResults(searchTerm: searchTerm, searchResults: self.contactPhotos), nil)
        })
        
    }
    
    func getPath() -> String {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0]
        return docsDir
    }
    
}
