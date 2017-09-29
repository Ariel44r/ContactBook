//
//  ContactPhoto.swift
//  Contact Book
//
//  Created by Ariel Ramírez on 23/09/17.
//  Copyright © 2017 Ariel Ramírez. All rights reserved.
//

import Foundation
import UIKit

class ContactPhoto: Equatable {
    
    var name: String
    var lastName: String
    var ID: String
    var cellPhone: String
    var imagePath: String = ""
    
    init (_ name: String,_ lastName: String,_ cellPhone: String) {
        self.name = name
        self.lastName = lastName
        self.cellPhone = cellPhone
        self.imagePath = ContactPhoto.getPath() + "/images/contact.png"
        self.ID = ""
    }
    
    //MARK: getImageFromPathWithID
    
    func getImageFromPathWithID () -> UIImage {
        if let currentImage = UIImage(contentsOfFile: self.imagePath) {
            return currentImage
        }
        return UIImage(named: "contact.png")!
    }
    
    
    /*func sizeToFillWidthOfSize (_ size: CGSize) -> CGSize {
        
        guard let photoTumbnail = photoTumbnail else {
            return size
        }
        
        let imageSize = photoTumbnail.size
        var returnSize = size
        
        let aspectRatio =  imageSize.width / imageSize.height
        
        returnSize.height = returnSize.width / aspectRatio
        
        if returnSize.height > size.height {
            returnSize.height = size.height
            returnSize.width = size.height * aspectRatio
        }
        return returnSize
    }*/
    
}

//MARK: FileManager
extension ContactPhoto {
    
    static func getPath() -> String {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0]
        return docsDir
    }
    
}

func == (lhs: ContactPhoto, rhs: ContactPhoto) -> Bool {
    return lhs.ID == rhs.ID
}
