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
    
    var contactDataBase = ContactDataBase()
    
    fileprivate var PATH = ""
    
    func receiveContactsAndAdd(contact: ContactPhoto) {
        contact.ID = getIDForNewImage()
        checkForEmptyFields()
        let newContact: ContactPhoto = contact
        contactDataBase.insertIntoDB(newContact)
    }
    
    func receiveImageChangeAndSave (_ image: UIImage, _ index: Int) {
        contactPhotos = contactDataBase.queryDataBase("*")
        let fManager = FileManager()
        let pngImage = UIImagePNGRepresentation(image)
        let PATH = contactDataBase.getPath().replacingOccurrences(of: "/ContactBook.db", with: "")
        if !fManager.fileExists(atPath: PATH + "/images") {
            do {
                try fManager.createDirectory(atPath: PATH + "/images", withIntermediateDirectories: false, attributes: nil)
            } catch (let exception){
                debugPrint (exception)
            }
            debugPrint("MASTER PATH: " + PATH)
        }
        fManager.createFile(atPath: PATH + "/images/" + String(index) + ".png", contents: pngImage, attributes: nil)
    }
    
    func deleteContact (index: Int) {
        contactDataBase.deleteContactWithID(String(index))
    }
    
    func searchContactForTerm(_ searchTerm: String, completion : @escaping (_ results: ContactSearchResults?, _ error: Error?) -> Void) {
        let receiveFromDataBase = contactDataBase.queryDataBase("*")
        var searchContactForName = [ContactPhoto]()        //SearchContactForName
        if searchTerm == "" {
            searchContactForName = contactDataBase.queryDataBase("*")
        } else {
            for currentContact in receiveFromDataBase {
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
        let receiveFromJSON = contactDataBase.queryDataBase("*")
        
        OperationQueue.main.addOperation({
            completion(ContactSearchResults(searchTerm: "*", searchResults: receiveFromJSON), nil)
        })
    }

}

//MARK: checkForEmptyFields
extension Contact {
    func checkForEmptyFields () {
        let contactPhotos = contactDataBase.queryDataBase("*")
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


