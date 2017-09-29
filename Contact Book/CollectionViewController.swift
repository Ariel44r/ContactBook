//
//  CollectionViewController.swift
//  Contact Book
//
//  Created by Ariel Ramírez on 22/09/17.
//  Copyright © 2017 Ariel Ramírez. All rights reserved.
//

import UIKit



class CollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    fileprivate let reuseIdentifier = "ContactCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate var searches = [ContactSearchResults]()
    fileprivate let contact = Contact()
    fileprivate let itemsPerRow: CGFloat = 2
    var currentIndexPhoto: Int = 0
    var contactPhoto = [ContactPhoto]()
    
    //MARK: Actions&Outlets
    
    //collectionViewOutlet
    @IBOutlet var collectionContacts: UICollectionView!
    
    //addContactActionButton
    @IBAction func addContact(_ sender: Any) {
        
        
        
    }
    
    @IBAction func showDetail(_ sender: Any) {
        self.performSegue(withIdentifier: "segueDetail", sender: nil)
        collectionContacts.reloadData()
    }
    
    //changeProfileImageActionButton
    @IBAction func contactChangePhoto(_ sender: Any) {
        
        print("Button change image from gallery are pressed")
        let image = UIImagePickerController()
        image.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        currentIndexPhoto = (sender as AnyObject).tag
        //assign value to currentIndexPhoto = sender.tag
        self.present(image,animated: true) {
            //after complete process
        }
        
    }
    
    //get image and assign to contact`s atribute
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("the index is: \(currentIndexPhoto)")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            contact.receiveImageChangeAndSave(image, currentIndexPhoto)
        }
        self.dismiss(animated: true, completion: nil)
        
        collectionContacts.reloadData()
        
    }

}

//ObtainPhotoForIndexPath
private extension CollectionViewController {
    
    func photoForIndexPath (indexPath: IndexPath) -> ContactPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
    
}

//MARK: UITextFieldDelegate
extension CollectionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        contact.searchContactForTerm(textField.text!) {
            results, error in
            
            activityIndicator.removeFromSuperview()
            
            if let error = error {
                print("Error searching \(error)")
                return
            }
            
            if let results = results {
                print("Have been Found: \(results.searchResults.count) matching for \(results.searchTerm)")
                self.searches.insert(results, at: 0)
                
                self.collectionContacts.reloadData()
            }
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
    
}

//MARK: UICollectionViewDataSource
extension CollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ContactPhotoCell
        let contactPhoto = photoForIndexPath(indexPath: indexPath)
        cell.backgroundColor = UIColor.white
        cell.contactPhoto.image = contactPhoto.getImageFromPathWithID()
        cell.contactChangePhoto.addTarget(self, action: #selector(CollectionViewController.contactChangePhoto(_:)), for: UIControlEvents.touchUpInside)
        cell.contactChangePhoto.tag = indexPath.item
        cell.contactName.text = contactPhoto.name
        return cell
    }
    
}

//MARK: UICollectionViewDelegateFlowLayout
extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}




