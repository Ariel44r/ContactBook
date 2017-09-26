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
    var cellPhone: String?
    var photoTumbnail: UIImage?
    
    init (name: String, lastName: String, ID: String) {
        self.name = name
        self.lastName = lastName
        self.ID = ID
    }
    
    func sizeToFillWidthOfSize (_ size: CGSize) -> CGSize {
        
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
    }
    
}

func == (lhs: ContactPhoto, rhs: ContactPhoto) -> Bool {
    return lhs.ID == rhs.ID
}
