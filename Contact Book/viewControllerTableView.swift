//
//  viewControllerTableView.swift
//  Contact Book
//
//  Created by Ariel Ramírez on 29/09/17.
//  Copyright © 2017 Ariel Ramírez. All rights reserved.
//

import UIKit

class viewControllerTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    fileprivate let reuseIdentifier: String = "ContactTableViewCell"
    fileprivate var searches = [ContactSearchResults]()
    fileprivate let contact = Contact()
    fileprivate let currentIndexPhoto: Int = 0
    
    //MARK: actionsAndOutlets
    
    //tableViewOutlet
    @IBOutlet weak var tableViewContacts: UITableView!
    
    @IBOutlet weak var viewHeader: UIView!
    
    
    @IBOutlet weak var textfieldSearch: UITextField!
    
    @IBAction func buttonSearch(_ sender: Any) {
        let search: Bool = textFieldShouldReturn(textfieldSearch)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        contact.searchContactForTerm("allContacts") {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        contact.searchContactForTerm(textField.text!) {
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
        
        textField.text = nil
        textField.resignFirstResponder()
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
        cell.UIImageContact.image = contactPhoto.getImageFromPathWithID(indexPath.row)
        return cell
        
    }
    
}
