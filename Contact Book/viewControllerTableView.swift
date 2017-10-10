//
//  viewControllerTableView.swift
//  Contact Book
//
//  Created by Ariel Ramírez on 29/09/17.
//  Copyright © 2017 Ariel Ramírez. All rights reserved.
//

import UIKit

class viewControllerTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,ContactDetailViewControllerDelegate, addOrChangeDataContactDelegate {
    
    fileprivate let reuseIdentifier: String = "ContactTableViewCell"
    fileprivate var searches = [ContactSearchResults]()
    fileprivate let contact = Contact()
    fileprivate var currentIndexPhoto: Int = 0
    var currentIndexPhotoItem = 0
    //MARK: actionsAndOutlets
    
    //tableViewOutlet
    @IBOutlet weak var tableViewContacts: UITableView!
    
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var textfieldSearch: UITextField!
  
    @IBAction func addContact(_ sender: Any) {
        self.performSegue(withIdentifier: "addContact", sender: nil)
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
    
    //DELEGATEFUNCTIONS
    func updateContacts() {
        contact.searchContactForTerm("") {
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
    
    func updateContactsFromAddOrChange() {
        contact.searchContactForTerm("") {
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
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableContactDetail" {
            let contactPhoto = sender as! ContactPhoto
            let detailVC = segue.destination as! ContactDetailViewController
            detailVC.contactPhoto = contactPhoto
            let sendIndex = segue.destination as! ContactDetailViewController
            sendIndex.index = currentIndexPhotoItem
            detailVC.delegate = self
        }
        if segue.identifier == "addContact" {
            let detailVC = segue.destination as! addOrChangeDataContact
            detailVC.delegate = self
        }
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
        cell.UIImageContact.image = contactPhoto.getImageFromPathWithID(indexPath.row)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactPhoto = photoForIndexPath(indexPath: indexPath)
        self.performSegue(withIdentifier: "tableContactDetail", sender: contactPhoto)
        currentIndexPhotoItem = indexPath.row
        
    }
    
}



