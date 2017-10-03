//
//  viewControllerTableView.swift
//  Contact Book
//
//  Created by Ariel Ramírez on 29/09/17.
//  Copyright © 2017 Ariel Ramírez. All rights reserved.
//

import UIKit

class viewControllerTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate let reuseIdentifier: String = "ContactTableViewCell"
    fileprivate var searches = [ContactSearchResults]()
    fileprivate let contact = Contact()
    fileprivate var currentIndexPhoto: Int = 0
    //MARK: actionsAndOutlets
    
    //tableViewOutlet
    @IBOutlet weak var tableViewContacts: UITableView!
    
    @IBOutlet weak var viewHeader: UIView!
    
    
    @IBOutlet weak var textfieldSearch: UITextField!

    @IBAction func actionSheet(_ sender: Any) {
        actionSheetFunc((sender as AnyObject).tag)
    }
    
    
  
    @IBAction func addContact(_ sender: Any) {
        self.performSegue(withIdentifier: "addContact", sender: nil)
        tableViewContacts.reloadData()
    }
    
    @IBAction func goToCollectionController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        contact.deployAllContatcsOnJson() {
            results, error in
            
            if let error = error {
                debugPrint("Error searching \(error)")
                return
            }
            
            if let results = results {
                debugPrint("Have been Found: \(results.searchResults.count) matching for \(results.searchTerm)")
                self.searches.insert(results, at: 0)
                
                self.tableViewContacts.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//ObtainPhotoForIndexPath
private extension viewControllerTableView {
    
    func photoForIndexPath (indexPath: IndexPath) -> ContactPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
    
}

//MARK: UITextFieldDelegate
extension viewControllerTableView: UITextFieldDelegate {
    
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
                
                self.tableViewContacts.reloadData()
            }
        }
        
        //textField.text = nil
        //textField.resignFirstResponder()
        return true
    }
    
}


//MARK: tableViewDelegate
extension viewControllerTableView {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var items: Int = 0
        if searches.count > 0 {
            items = searches[section].searchResults.count
        } else {
            items = searches.count
        }
        return items
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! tableViewCell
        let contactPhoto = photoForIndexPath(indexPath: indexPath)
        cell.labelContact.text = contactPhoto.name
        cell.actionSheet.tag = indexPath.row
        cell.UIImageContact.image = contactPhoto.getImageFromPathWithID(indexPath.row)
        cell.actionSheet.addTarget(self, action: #selector(viewControllerTableView.actionSheet(_:)), for: UIControlEvents.touchUpInside)
        return cell
        
    }
    
}

//MARK: actionSheetExtension
extension viewControllerTableView {
    //actionSheetFunc
    func actionSheetFunc(_ index: Int) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
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
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            debugPrint("Item Deleted")
            self.contact.deleteContact(index: index)
            self.contact.searchContactForTerm("") {
                results, error in
                if let error = error {
                    debugPrint("Error searching \(error)")
                    return
                }
                if let results = results {
                    debugPrint("Have been Found: \(results.searchResults.count) matching for \(results.searchTerm)")
                    self.searches.insert(results, at: 0)
                    self.tableViewContacts.reloadData()
                }
            }
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
        tableViewContacts.reloadData()
        
    }
}

