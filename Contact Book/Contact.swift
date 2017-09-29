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
        checkForEmptyFields()
        let newContact = contact
        contactPhotos.append(newContact)
        debugPrint("Contact \(newContact.name) append at contactPhotos in the index: \(contactPhotos.count - 1)")
        
        for con in contactPhotos {
            debugPrint("Name: \(con.name), Last Name: \(con.lastName), ID: \(con.ID), Cell Phone: \(con.cellPhone), Image: path: \(con.imagePath)")
        }
        saveDataOnJSONFile("ContactBook", "json")
        receiveObjectFromJSON()
        
    }
    
    func receiveImageChangeAndSave (_ image: UIImage, _ index: Int) {
        
        
        let fManager = FileManager()
        let pngImage = UIImagePNGRepresentation(image)
        if !fManager.fileExists(atPath: getPath() + "/images") {
            do {
                try fManager.createDirectory(atPath: getPath() + "/images", withIntermediateDirectories: false, attributes: nil)
            } catch (let exception){
                debugPrint (exception)
            }
            
        }
        var IDPhoto: String = ""
        if contactPhotos[index].ID == "" {
            IDPhoto = String(index)
        } else {
            IDPhoto = contactPhotos[index].ID
        }
        
        contactPhotos[index].imagePath = getPath() + "/images/\(IDPhoto).png"
        fManager.createFile(atPath: contactPhotos[index].imagePath, contents: pngImage, attributes: nil)
        
    }
    
    func searchContactForTerm(_ searchTerm: String, completion : @escaping (_ results: ContactSearchResults?, _ error: Error?) -> Void) {
        
        
        debugPrint("Search Term typed is: \(searchTerm)")
        
        //Add actions to find Contact for searchTerm
        
        debugPrint("searchContactForTermFunc says: The number of contacts is: \(contactPhotos.count)")
        
        //receiveobjectfrom JSON
        
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
    
    func saveDataOnJSONFile (_ fileName: String, _ xtension: String) {
        
        checkForEmptyFields()
        var topLevel_: [AnyObject] = []
        for contactPhoto in contactPhotos {
            var contactDictionary: NSMutableDictionary = NSMutableDictionary()
            //var contactDictionary: Dictionary = Dictionary()
            contactDictionary.setValue(contactPhoto.name, forKey: "name")
            contactDictionary.setValue(contactPhoto.lastName, forKey: "lastName")
            contactDictionary.setValue(contactPhoto.ID, forKey: "ID")
            contactDictionary.setValue(contactPhoto.cellPhone, forKey: "cellPhone")
            contactDictionary.setValue(contactPhoto.imagePath, forKey: "imagePath")

            topLevel_.append(contactDictionary)
        }
        let topLevel = NSArray(array: topLevel_)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: topLevel, options: .prettyPrinted)
            let fileManager = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = fileManager.appendingPathComponent(fileName + "." + xtension)
            
            debugPrint("JSON  File Path: \(fileURL.path)")
            
            let writeString = String(data: jsonData,encoding: .ascii)
            do{
                //Write the file
                try writeString?.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                debugPrint ("Failed to write on \(fileName).\(xtension)")
                debugPrint(error)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}

//MARK: receiveObjectFromJSON
extension Contact {
    func receiveObjectFromJSON ()  {
        
        var contactReceived = [ContactPhoto]()
        
        //read the json file
        let fileManager = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let jsonURL = fileManager.appendingPathComponent("ContactBook.json")
        let jsonReadData: Data
        do {
            jsonReadData = try Data(contentsOf: jsonURL)
             let parsedContacts = try JSONSerialization.jsonObject(with: jsonReadData, options: .mutableContainers)
            let contacts = parsedContacts as! [[String: AnyObject]]
            for contact in contacts {
                
                guard let contactName = contact["name"] as? String,
                let contactlast = contact["lastName"] as? String,
                let contactid = contact["ID"] as? String,
                let contactcellphone = contact["cellPhone"] as? String,
                    let contactimagepath = contact["imagePath"] as? String
                else{ continue}
                let ContactParse = ContactPhoto(contactName,contactlast,contactcellphone)
                contactReceived.append(ContactParse)
            }
            for contact in contactReceived {
                print ("contact from JSON file: \(contact)")
            }
        } catch {
            print(error)
        }
        
      
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
        let ID: String
        if contactPhotos.count == 0 {
            ID = String(contactPhotos.count)
        } else {
            ID = String(contactPhotos.count - 1)
        }
        return ID
    }
}

