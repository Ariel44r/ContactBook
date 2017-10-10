//
//  ContactDetailViewController.swift
//  Contact Book
//
//  Created by Ariel Ramírez on 03/10/17.
//  Copyright © 2017 Ariel Ramírez. All rights reserved.
//

import UIKit

protocol ContactDetailViewControllerDelegate: class {
    func updateContacts()
}

class ContactDetailViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: InstancesAndVariables
    var contact = Contact()
    fileprivate var searches = [ContactSearchResults]()
    var contactPhoto: ContactPhoto?
    var index: Int?
    var indexImage: Int?
    let dataBase = ContactDataBase()
    weak var delegate: ContactDetailViewControllerDelegate?
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.updateContacts()
    }
    
    //MARK: OutletsAndActions
    
    @IBAction func actionSheet(_ sender: Any) {
        actionSheetFunc(Int((contactPhoto?.ID)!)!)
        print("INDEX: " + (contactPhoto?.ID)!)
    }
    
    
    @IBOutlet weak var imageContact: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var cellPhonetextField: UITextField!
    
    
    @IBAction func changeImage(_ sender: Any) {
        actionSheetFuncImage(Int((contactPhoto?.ID)!)!)
        delegate?.updateContacts()
    }
    
    @IBAction func editButton(_ sender: Any) {
        nameTextField.isUserInteractionEnabled = true
        lastNameTextField.isUserInteractionEnabled = true
        cellPhonetextField.isUserInteractionEnabled = true
    }
    
    @IBAction func updateContact(_ sender: Any) {
        let currentContact = ContactPhoto(nameTextField.text!,lastNameTextField.text!,cellPhonetextField.text!)
        let indexString: String = contactPhoto!.ID
        debugPrint("ID TO UPDATE: " + indexString)
        currentContact.setIDAndImagePath(indexString, dataBase.getPath())
        dataBase.updateRecord(currentContact)
        delegate?.updateContacts()
        displayalert(userMessage: "Contact updated successfully")
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
            nameTextField.text = contactPhoto!.name
            nameTextField.isUserInteractionEnabled = false
        }
        if contactPhoto?.lastName != nil {
            lastNameTextField.text = contactPhoto!.lastName
            lastNameTextField.isUserInteractionEnabled = false
        }
        if contactPhoto?.cellPhone != nil {
            cellPhonetextField.text = contactPhoto!.cellPhone
            cellPhonetextField.isUserInteractionEnabled = false
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

//MARK: actionSheets
extension ContactDetailViewController {
    
    
    func actionSheetFunc(_ index: Int) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            debugPrint("Item Deleted")
            self.contact.deleteContact(index: index)
            self.displayalert(userMessage: "Contact deleted successfully")
            self.back()
            self.delegate?.updateContacts()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
    
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func actionSheetFuncImage(_ index: Int) {
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        optionMenu.addAction(changeImageAction)
        optionMenu.addAction(takeAPicture)
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
    
    func back() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Alerts
extension ContactDetailViewController {
    
    //display_alert_function
    func displayalert(userMessage:String) {
        let myalert = UIAlertController(title:"Notice", message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.default, handler:nil)
        myalert.addAction(okAction)
        self.present(myalert, animated:true, completion:nil)
    }
    
}

