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
    
   //actionSheet
    @IBAction func actionSheet(_ sender: Any) {
        actionSheetFunc((sender as AnyObject).tag)
    }
    
    
    @IBAction func showDetail(_ sender: Any) {
        self.performSegue(withIdentifier: "segueDetail", sender: nil)
        collectionContacts.reloadData()
    }
    
    @IBAction func segueTableView(_ sender: Any) {
        self.performSegue(withIdentifier: "segueTableView", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        contact.deployAllContatcsOnJson(){
            results, error in
            
            if let error = error {
                debugPrint("Error searching \(error)")
                return
            }
            
            if let results = results {
                debugPrint("Have been Found: \(results.searchResults.count) matching for \(results.searchTerm)")
                self.searches.insert(results, at: 0)
                
                self.collectionContacts.reloadData()
            }
        }
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        
        var newText:String
        if(string != ""){
            newText = textField.text! + string
        }else{
            newText = textField.text!.substring(to: textField.text!.index(before: textField.text!.endIndex))
        }
        
        contact.searchContactForTerm(newText) {
            results, error in
            
            activityIndicator.removeFromSuperview()
            
            if let error = error {
                debugPrint("Error searching \(error)")
                return
            }
            
            if let results = results {
                debugPrint("Have been Found: \(results.searchResults.count) matching for \(results.searchTerm)")
                self.searches.insert(results, at: 0)
                
                self.collectionContacts.reloadData()
            }
        }
        
        //textField.text = nil
        //textField.resignFirstResponder()
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
        cell.contactPhoto.image = contactPhoto.getImageFromPathWithID(indexPath.item)
        cell.actionSheet.addTarget(self, action: #selector(CollectionViewController.actionSheet(_:)), for: UIControlEvents.touchUpInside)
        cell.actionSheet.tag = indexPath.item
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

//MARK: actionSheetExtension
extension CollectionViewController {
    //actionSheetFunc
    func actionSheetFunc(_ index: Int) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            debugPrint("Item Deleted")
        })
        let changeImageAction = UIAlertAction(title: "Choose Image from Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            debugPrint("Chose Image From Gallery")
            
            debugPrint("Button change image from gallery are pressed")
            let image = UIImagePickerController()
            image.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
            image.allowsEditing = false
            self.currentIndexPhoto = index
            self.present(image,animated: true) {
                //after complete process
            }
            
        })
        
        let takeAPicture = UIAlertAction(title: "Take a picture", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            debugPrint("Take a Picture")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        optionMenu.addAction(changeImageAction)
        optionMenu.addAction(takeAPicture)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //get image and assign to contact`s atribute
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            contact.receiveImageChangeAndSave(image, currentIndexPhoto)
        }
        self.dismiss(animated: true, completion: nil)
        collectionContacts.reloadData()
        
    }
}

