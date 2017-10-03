//
//  addOrChangeDataContact.swift
//  Contact Book
//
//  Created by Ariel Ramírez on 26/09/17.
//  Copyright © 2017 Ariel Ramírez. All rights reserved.
//

import UIKit

class addOrChangeDataContact: UIViewController {
    
    //MARK: VariablesAndInstances
    var contact = Contact()
    var name: String = ""
    
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
      
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: Alerts
extension addOrChangeDataContact {
    
    //display_alert_function
    func displayalert(userMessage:String) {
        let myalert = UIAlertController(title:"Aviso", message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"ok", style: UIAlertActionStyle.default, handler:nil)
        myalert.addAction(okAction)
        self.present(myalert, animated:true, completion:nil)
    }
    
}

