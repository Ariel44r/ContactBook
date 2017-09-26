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
    
    func receiveContactsAndAdd(contact: ContactPhoto) {
        
        contactPhotos.append(contact)
        
    }
    
    func getPath() -> String {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0]
        return docsDir
    }
    
    func receiveImageChangeAndSave (_ image: UIImage, _ index: Int) {
        
        contactPhotos[index].photoTumbnail = image
        
        let fManager = FileManager()
        let pngImage = UIImagePNGRepresentation(contactPhotos[index].photoTumbnail!)
        if !fManager.fileExists(atPath: getPath() + "images") {
            do {
                try fManager.createDirectory(atPath: getPath() + "/images", withIntermediateDirectories: false, attributes: nil)
            } catch (let exception){
                print (exception)
            }
            
        }
        let nameString: String = contactPhotos[index].name
        fManager.createFile(atPath: getPath() + "/images/\(nameString).png", contents: pngImage, attributes: nil)
        
    }
    
    func searchContactForTerm(_ searchTerm: String, completion : @escaping (_ results: ContactSearchResults?, _ error: Error?) -> Void) {
        
        let contacto = ContactPhoto("Ariel","Ramírez","5576604221")
        contactPhotos.append(contacto)
        
        
        print("Search Term typed is: \(searchTerm)")
        
        //Add actions to find Contact for searchTerm
        
        print("PATH: \(getPath())")
        print("The number of contacts is: \(contactPhotos.count)")
        
        for index in 0 ..< contactPhotos.count {
            
            contactPhotos[index].photoTumbnail = #imageLiteral(resourceName: "contact")
            contactPhotos[index].ID = String(index)
            //find term String by String
            
        }
        
        OperationQueue.main.addOperation({
            completion(ContactSearchResults(searchTerm: searchTerm, searchResults: self.contactPhotos), nil)
        })
        
    }
    

    
}
