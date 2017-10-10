//
//  addOrChangeDataContact.swift
//  Contact Book
//
//  Created by Ariel Ramírez on 26/09/17.
//  Copyright © 2017 Ariel Ramírez. All rights reserved.
//

import UIKit

protocol addOrChangeDataContactDelegate: class {
    func updateContactsFromAddOrChange()
}

class addOrChangeDataContact: UIViewController {
    
    //MARK: VariablesAndInstances
    var contact = Contact()
    var name: String = ""
    weak var delegate: addOrChangeDataContactDelegate?
    
    //MARK: OutletsAndActions
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var labelCellPhone: UILabel!
    @IBOutlet weak var textFieldCellPhone: UITextField!
    
    @IBAction func actionButtonRecord(_ sender: Any) {
    
        name = textFieldName.text!
        if name != "" {
            let lastName = textFieldLastName.text!
            let cellPhone = textFieldCellPhone.text!
            let contactPhoto = ContactPhoto(name, lastName, cellPhone)
            contact.receiveContactsAndAdd(contact: contactPhoto)
        } else {
            displayalert(userMessage: "You must enter at least the name :)")
        }
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
        delegate?.updateContactsFromAddOrChange()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: Alerts
extension addOrChangeDataContact {
    
    //display_alert_function
    func displayalert(userMessage:String) {
        let myalert = UIAlertController(title:"Notice", message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.default, handler:nil)
        myalert.addAction(okAction)
        self.present(myalert, animated:true, completion:nil)
    }
    
}

