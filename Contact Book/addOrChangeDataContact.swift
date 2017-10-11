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

class addOrChangeDataContact: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        labelName.tag = 0
        labelLastName.tag = 1
        labelCellPhone.tag = 2
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) {
            notification in
            self.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) {
            notification in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height,right: 0)
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification){
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    //MARK: textFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textFieldCellPhone {
            let cgpoint: CGPoint = CGPoint(x: 0,y: 200)
            scrollView.setContentOffset(cgpoint, animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cgpoint: CGPoint = CGPoint(x: 0,y: 0)
        scrollView.setContentOffset(cgpoint, animated: true)
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

