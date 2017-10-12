//
//  CollectionViewController.swift
//  Contact Book
//
//  Created by Ariel Ramírez on 22/09/17.
//  Copyright © 2017 Ariel Ramírez. All rights reserved.
//

import UIKit



class CollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ContactDetailViewControllerDelegate, addOrChangeDataContactDelegate {

    fileprivate let reuseIdentifier = "ContactCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate var searches = [ContactSearchResults]()
    fileprivate let contact = Contact()
    fileprivate let itemsPerRow: CGFloat = 2
    var currentIndexPhoto: Int = 0
    
    //MARK: Actions&Outlets
    
    //collectionViewOutlet
    @IBOutlet var collectionContacts: UICollectionView!
    
    @IBAction func showDetail(_ sender: Any) {
        self.performSegue(withIdentifier: "segueDetail", sender: nil)
        collectionContacts.reloadData()
    }
    
    @IBAction func segueTableView(_ sender: Any) {
        self.performSegue(withIdentifier: "segueTableView", sender: nil)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "viewControllerTableView") as! viewControllerTableView
        //vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        contact.deployAllContatcsOnDataBase(){
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
    
    //DELEGATEFUNCTION
    func updateContacts() {
        refreshContacts("")
    }
    
    func updateContactsFromAddOrChange() {
        refreshContacts("")
    }
}

//ObtainPhotoForIndexPath
private extension CollectionViewController {
    
    func photoForIndexPath (indexPath: IndexPath) -> ContactPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
    
}

//MARK: refreshContacts
extension CollectionViewController {
    func refreshContacts(_ searchTerm: String) {
        contact.searchContactForTerm(searchTerm) {
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
        activityIndicator.removeFromSuperview()
        refreshContacts(newText)
        
        //textField.text = nil
        //textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionContactDetail" {
            let contactPhoto = sender as! ContactPhoto
            let detailVC = segue.destination as! ContactDetailViewController
            detailVC.contactPhoto = contactPhoto
            let sendIndex = segue.destination as! ContactDetailViewController
            sendIndex.index = currentIndexPhoto
            detailVC.delegate = self
        }
        if segue.identifier == "segueDetail" {
            let detailVC = segue.destination as! addOrChangeDataContact
            detailVC.delegate = self
        }
    }
    
}

//MARK: UICollectionViewDataSource
extension CollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items: Int = 0
        if searches.count > 0 {
            items = searches[section].searchResults.count
        } else {
            items = searches.count
        }
        return items
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ContactPhotoCell
        let contactPhoto = photoForIndexPath(indexPath: indexPath)
        cell.backgroundColor = UIColor.white
        cell.contactPhoto.image = contactPhoto.getImageFromPathWithID(indexPath.item)
        cell.contactName.text = contactPhoto.name
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contactPhoto = photoForIndexPath(indexPath: indexPath)
        self.performSegue(withIdentifier: "collectionContactDetail", sender: contactPhoto)
        currentIndexPhoto = indexPath.item
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
