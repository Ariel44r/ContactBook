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
    
    fileprivate var PATH = ""
    
    func receiveContactsAndAdd(contact: ContactPhoto) {
        
        contactPhotos = receiveObjectFromJSON()
        contact.ID = getIDForNewImage()
        contact.imagePath = PATH
        checkForEmptyFields()
        let newContact = contact
        contactPhotos.append(newContact)
        
        for con in contactPhotos {
            debugPrint("Name: \(con.name), Last Name: \(con.lastName), ID: \(con.ID), Cell Phone: \(con.cellPhone), Image: path: \(con.imagePath)")
        }
        saveDataOnJSONFile(contactPhotos, "ContactBook", "json")
        
    }
    
    func receiveImageChangeAndSave (_ image: UIImage, _ index: Int) {
        contactPhotos = receiveObjectFromJSON()
        let fManager = FileManager()
        let pngImage = UIImagePNGRepresentation(image)
        if !fManager.fileExists(atPath: PATH + "/images") {
            do {
                try fManager.createDirectory(atPath: PATH + "/images", withIntermediateDirectories: false, attributes: nil)
            } catch (let exception){
                debugPrint (exception)
            }
            debugPrint("MASTER PATH: " + PATH)
        }
       
        
        contactPhotos[index].imagePath = PATH + "/images/" + String(index) + ".png"
       
        fManager.createFile(atPath: contactPhotos[index].imagePath, contents: pngImage, attributes: nil)
        saveDataOnJSONFile(contactPhotos, "ContactBook", "json")
    }
    
    func deleteContact (index: Int) {
        contactPhotos = receiveObjectFromJSON()
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: PATH + "/images/\(contactPhotos[index].ID).png")
        } catch {
            debugPrint("Somthing went wrong at remove image \(error)")
        }
        contactPhotos.remove(at: index)
        saveDataOnJSONFile(contactPhotos, "ContactBook", "json")
    }
    
    func searchContactForTerm(_ searchTerm: String, completion : @escaping (_ results: ContactSearchResults?, _ error: Error?) -> Void) {
        
        //receiveobjectfrom JSON
        let receiveFromJSON = receiveObjectFromJSON()
        var searchContactForName = [ContactPhoto]()        //SearchContactForName
        if searchTerm == "" {
            searchContactForName = receiveFromJSON
        } else {
            for currentContact in receiveFromJSON {
                if (currentContact.name.lowercased().range(of: searchTerm.lowercased()) != nil) {
                    searchContactForName.append(currentContact)
                }
            }
        }
        OperationQueue.main.addOperation({
            completion(ContactSearchResults(searchTerm: searchTerm, searchResults: searchContactForName), nil)
        })
    }
    
    func deployAllContatcsOnJson (completion : @escaping (_ results: ContactSearchResults?, _ error: Error?) -> Void) {
        let receiveFromJSON = receiveObjectFromJSON()
        
        OperationQueue.main.addOperation({
            completion(ContactSearchResults(searchTerm: "*", searchResults: receiveFromJSON), nil)
        })
    }

}


//MARK: SaveDataOnJsonFileFunction
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
            let writeString = String(data: jsonData,encoding: .ascii)
            do{
                //Write the file
                try writeString?.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                debugPrint ("Failed to write on \(fileName).\(xtension)")
                debugPrint(error)
            }
        } catch {
            debugPrint(error.localizedDescription)
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
        if PATH == "" {
            PATH = jsonURL.path
            PATH = PATH.replacingOccurrences(of: "/ContactBook.json", with: "")
        }
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
        } catch {
            debugPrint(error)
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


