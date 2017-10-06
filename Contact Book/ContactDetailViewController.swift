//
//  ContactDetailViewController.swift
//  Contact Book
//
//  Created by Ariel Ramírez on 03/10/17.
//  Copyright © 2017 Ariel Ramírez. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: InstancesAndVariables
    var contact = Contact()
    fileprivate var searches = [ContactSearchResults]()
    var contactPhoto: ContactPhoto?
    var index: Int?
    var indexImage: Int?
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: OutletsAndActions
    
    @IBAction func actionSheet(_ sender: Any) {
        actionSheetFunc(Int((contactPhoto?.ID)!)!)
        print("INDEX: " + (contactPhoto?.ID)!)
    }
    
    
    @IBOutlet weak var imageContact: UIImageView!
    
    @IBOutlet weak var nameContactlabel: UILabel!
    
    @IBOutlet weak var lastNameContactLabel: UILabel!
    
    @IBOutlet weak var cellPhoneContactLabel: UILabel!
    
    @IBAction func doneContactButton(_ sender: Any) {
        //returnToPrevVC
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if index != nil {
            imageContact.image = contactPhoto!.getImageFromPathWithID(index!)
        }
        if contactPhoto?.name != nil {
            nameContactlabel.text = contactPhoto!.name
        }
        if contactPhoto?.lastName != nil {
            lastNameContactLabel.text = contactPhoto!.lastName
        }
        if contactPhoto?.cellPhone != nil {
            cellPhoneContactLabel.text = contactPhoto!.cellPhone
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

extension ContactDetailViewController {
    
    
    func actionSheetFunc(_ index: Int) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let changeImageAction = UIAlertAction(title: "Choose Image from Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            debugPrint("Chose Image From Gallery whit INDEX \(index)")
            self.indexImage = index
            let image = UIImagePickerController()
            image.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
            image.allowsEditing = false
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
                    self.searches.insert(results, at: 0)
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
            contact.receiveImageChangeAndSave(image, indexImage!)
            print("SAVE PHOTO WHIT ID: \(indexImage!)")
        }
        self.dismiss(animated: true, completion: nil)        
    }
    
}
