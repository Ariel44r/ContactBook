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
        self.imagePath = ""
        self.ID = ""
    }
    
    func setIDAndImagePath(_ ID: String, _ imagePath: String) {
        self.ID = ID
        self.imagePath = imagePath
        debugPrint(imagePath)
    }
    
    //MARK: getImageFromPathWithID
    
    func getImageFromPathWithID (_ index: Int) -> UIImage {
        let currentIm: UIImage
        debugPrint("IMAGEPATHFROM getImageFromPathWithID: \(self.imagePath)")
        if let currentImage = UIImage(contentsOfFile: self.imagePath) {
            currentIm = currentImage
        } else {
            currentIm = UIImage(named: "contact.png")!
        }
        return currentIm
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



func == (lhs: ContactPhoto, rhs: ContactPhoto) -> Bool {
    return lhs.ID == rhs.ID
}
