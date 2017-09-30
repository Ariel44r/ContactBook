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
        
        contactPhotos = receiveObjectFromJSON()
        contact.ID = getIDForNewImage()
        contact.imagePath = getPath()
        checkForEmptyFields()
        let newContact = contact
        contactPhotos.append(newContact)
        debugPrint("Contact \(newContact.name) append at contactPhotos in the index: \(contactPhotos.count - 1)")
        
        for con in contactPhotos {
            debugPrint("Name: \(con.name), Last Name: \(con.lastName), ID: \(con.ID), Cell Phone: \(con.cellPhone), Image: path: \(con.imagePath)")
        }
        saveDataOnJSONFile(contactPhotos, "ContactBook", "json")
        
        
    }
    
    func receiveImageChangeAndSave (_ image: UIImage, _ index: Int) {
        
        contactPhotos = receiveObjectFromJSON()
        let fManager = FileManager()
        let pngImage = UIImagePNGRepresentation(image)
        if !fManager.fileExists(atPath: getPath() + "/images") {
            do {
                try fManager.createDirectory(atPath: getPath() + "/images", withIntermediateDirectories: false, attributes: nil)
            } catch (let exception){
                debugPrint (exception)
            }
            
        }
       
        
        contactPhotos[index].imagePath = getPath() + "/images/\(index).png"
        fManager.createFile(atPath: contactPhotos[index].imagePath, contents: pngImage, attributes: nil)
        saveDataOnJSONFile(contactPhotos, "ContactBook", "json")
    }
    
    func searchContactForTerm(_ searchTerm: String, completion : @escaping (_ results: ContactSearchResults?, _ error: Error?) -> Void) {
        
        
        debugPrint("Search Term typed is: \(searchTerm)")
        
        //Add actions to find Contact for searchTerm
        
        debugPrint("searchContactForTermFunc says: The number of contacts is: \(contactPhotos.count)")
        
        //receiveobjectfrom JSON
        let receiveFromJSON = receiveObjectFromJSON()
        
        OperationQueue.main.addOperation({
            completion(ContactSearchResults(searchTerm: searchTerm, searchResults: receiveFromJSON), nil)
        })
        
    }

}


//MARK: SaveDataOnJsonFileAndPrintOnConsoleFunctions
extension Contact {
    
    func saveDataOnJSONFile (_ contactPHoto: [ContactPhoto], _ fileName: String, _ xtension: String) {
        
        checkForEmptyFields()
        var topLevel_: [AnyObject] = []
        for contactPhoto in contactPHoto {
            let contactDictionary: NSMutableDictionary = NSMutableDictionary()
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
            
            debugPrint("JSON FILE PATH: \(fileURL.path)")
            
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
    func receiveObjectFromJSON () -> [ContactPhoto] {
        
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
                ContactParse.setIDAndImagePath(contactid, contactimagepath)
                contactReceived.append(ContactParse)
            }
            for contact in contactReceived {
                print ("contact from JSON file: Name: \(contact.name), Last Nme:  \(contact.lastName), ID: \(contact.ID), imagePath: \(contact.imagePath)")
            }
        } catch {
            print(error)
        }
       return contactReceived
      
    }
}

//MARK: checkForEmptyFields
extension Contact {
    
    func checkForEmptyFields () {
        let contactPhotos = receiveObjectFromJSON()
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
        return String(contactPhotos.count)
    }
}

//MARK: fileManager
extension Contact {
    func getPath() -> String {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0]
        return docsDir
    }
}

