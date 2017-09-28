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
        
        contact.ID = getIDForNewImage()
       
        contactPhotos.append(contact)
        debugPrint("Contact \(contact.name) append at contactPhotos in the index: \(contactPhotos.count - 1)")
        
    }
    
    func receiveImageChangeAndSave (_ image: UIImage, _ index: Int) {
        
        
        let fManager = FileManager()
        let pngImage = UIImagePNGRepresentation(image)
        if !fManager.fileExists(atPath: getPath() + "images") {
            do {
                try fManager.createDirectory(atPath: getPath() + "/images", withIntermediateDirectories: false, attributes: nil)
            } catch (let exception){
                debugPrint (exception)
            }
            
        }
        var IDPhoto: String = ""
        if contactPhotos[index].ID == nil {
            IDPhoto = getIDForNewImage()
        } else {
            IDPhoto = contactPhotos[index].ID!
        }
        
        contactPhotos[index].imagePath = getPath() + "/images/\(IDPhoto).png"
        fManager.createFile(atPath: contactPhotos[index].imagePath, contents: pngImage, attributes: nil)
        
    }
    
    func searchContactForTerm(_ searchTerm: String, completion : @escaping (_ results: ContactSearchResults?, _ error: Error?) -> Void) {
        
        let contacto = ContactPhoto("Ariel","Ramírez","5576604221")
        contactPhotos.append(contacto)
        
        
        
        debugPrint("Search Term typed is: \(searchTerm)")
        
        //Add actions to find Contact for searchTerm
        
        debugPrint("PATH: \(getPath())")
        debugPrint("searchContactForTermFunc says: The number of contacts is: \(contactPhotos.count)")
        
        saveDataOnJSONFile(contacto, "ContactBook", "json")
        
        
        OperationQueue.main.addOperation({
            completion(ContactSearchResults(searchTerm: searchTerm, searchResults: self.contactPhotos), nil)
        })
        
    }

}

//MARK: FileManager
extension Contact {
    
    func getPath() -> String {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0]
        return docsDir
    }
    
}

//MARK: SaveDataOnJsonFileAndPrintOnConsoleFunctions
extension Contact {
    
    func saveDataOnJSONFile (_ contactPhoto: ContactPhoto, _ fileName: String, _ xtension: String) {
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension(xtension)
        
        debugPrint("file Path: \(fileURL.path)")
        
        
        
        let writeString = "{\"name\": \"\(contactPhoto.name)\", \"lastName\": \"\(String(describing: contactPhoto.lastName))\", \"ID\": \"\(String(describing: contactPhoto.ID))\", \"cellPhone\": \"\(String(describing: contactPhoto.cellPhone))\"}"
        
        checkForEmptyFields()
        
        if JSONSerialization.isValidJSONObject(contactPhotos) {
            debugPrint("contactPhoto are JSON serialization object")
            
            do {
                let JSONData = try JSONSerialization.data(withJSONObject: contactPhotos, options: .prettyPrinted)
                debugPrint("The data on JSON file are: \(JSONData)")
            } catch let error as NSError {
                debugPrint("The JSON file are not generated")
                debugPrint(error)
            }
            
        } else {
            debugPrint("contactPhoto are not a JSON serialization object")
        }
        
        do{
            //Write the file
            try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            debugPrint ("Failed to write on \(fileName).\(xtension)")
            debugPrint(error)
        }
        
        //read the file and print on console
        
        var readString = ""
        do {
            //Read the file
            readString = try String(contentsOf: fileURL)
        } catch let error as NSError {
            debugPrint("Failed to read on \(fileName).\(xtension)")
            debugPrint(error)
        }
        
        debugPrint("The contents of file \(fileName).\(xtension) are: \(readString)")
    }
    
        
    
        
    
}


//MARK: checkForEmptyFields
extension Contact {
    
    func checkForEmptyFields () {
        
        for indexContact in contactPhotos {
            
            if indexContact.lastName == "" {
                indexContact.lastName = "_"
            }
            if indexContact.cellPhone == "" {
                indexContact.cellPhone = "_"
            }
            
        }
        
    }
    
}

extension Contact {
    func getIDForNewImage() -> String {
        let ID = String(contactPhotos.count - 1)
        return ID
    }
}

