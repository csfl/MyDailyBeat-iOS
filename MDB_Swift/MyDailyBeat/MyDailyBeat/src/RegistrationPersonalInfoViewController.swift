//
//  RegistrationScreenNameViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 3/20/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit
import EasyTipView
import API

let START_INTERVAL: TimeInterval = -3773952000
let END_INTERVAL  : TimeInterval = -660441600

class RegistrationPersonalInfoViewController: UIViewController {
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var firstField: UITextField!
    @IBOutlet var lastField: UITextField!
    @IBOutlet var dobField: UITextField!
    @IBOutlet var firstOuter: UITextField!
    @IBOutlet var lastOuter: UITextField!
    @IBOutlet var dobOuter: UITextField!
    @IBOutlet var picker: UIDatePicker!
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet var doneButton: UIBarButtonItem!
    var userExists = false
    var birthDay: Date = Date()
    var tipView: EasyTipView =  EasyTipView(text: "ToolTip")
    var nextPage: (() -> ()) = {
        // empty by default
    }
    
    func makeAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func next(_ sender: Any) {
        if let firstName = self.firstField.text, let lastName = self.lastField.text {
            self.userExistsCheck(firstName: firstName, lastName: lastName)
        }
        guard isValidInput else {
            // TODO: Show error messages here.
            if !allFieldsFilledIn {
                self.makeAlert(with: "Form not complete.", and: "One or more of the fields on this page are not filled in. Please enter valid input for all the fields on this page.")
            } else {
                self.makeAlert(with: "User already exists", and: "A user of this name already exists. Please attempt to login, or use the 'Forgot Username/Forgot Password' tools if you have forgotten your login information.")
            }
            return
        }
        let obj = RegistrationObject.getInstance()
        obj.fname = firstField.text!
        obj.lname = lastField.text!
        obj.birthday = self.birthDay
        RegistrationObject.updateInstance(modified: obj)
        self.nextPage()
    }
    
    var isValidInput: Bool {
        guard allFieldsFilledIn else {
            return false
        }
        
        self.textFieldDidEndEditing(self.lastField)
        return !userExists
    }
    
    var allFieldsFilledIn: Bool {
        var result = false
        if let name = self.firstField.text, let pass1 = self.lastField.text, let pass2 = self.dobField.text, name != "" && pass1 != "" && pass2 != "" {
            result = true
        }
        return result
    }
    
    override var nibName: String? {
        get {
            return "RegistrationPersonalInfoViewController"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstField.delegate = self
        self.lastField.delegate = self
        self.dobField.delegate = self
        self.firstOuter.delegate = DisableOuterField()
        self.lastOuter.delegate = DisableOuterField()
        self.dobOuter.delegate = DisableOuterField()
        self.firstField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.dobField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.lastField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.firstOuter.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.lastOuter.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.dobOuter.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        self.firstOuter.layer.borderColor = UIColor.white.cgColor
        self.firstOuter.layer.borderWidth = 2
        self.firstOuter.layer.cornerRadius = 8
        self.firstOuter.clipsToBounds = true
        self.lastOuter.layer.borderColor = UIColor.white.cgColor
        self.lastOuter.layer.borderWidth = 2
        self.lastOuter.layer.cornerRadius = 8
        self.lastOuter.clipsToBounds = true
        self.dobOuter.layer.borderColor = UIColor.white.cgColor
        self.dobOuter.layer.borderWidth = 2
        self.dobOuter.layer.cornerRadius = 8
        self.dobOuter.clipsToBounds = true
        
        firstField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor(netHex: 0x0097A4)])
        lastField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor(netHex: 0x0097A4)])
        dobField.attributedPlaceholder = NSAttributedString(string: "Date of Birth", attributes: [NSAttributedStringKey.foregroundColor: UIColor(netHex: 0x0097A4)])
        dobField.inputView = self.picker
        dobField.inputAccessoryView = self.toolbar
        self.picker.datePickerMode = .date
        self.picker.minimumDate = Date(timeInterval: START_INTERVAL, since: Calendar.current.startOfDay(for: Date()))
        self.picker.maximumDate = Date(timeInterval: END_INTERVAL, since: Calendar.current.startOfDay(for: Date()))
        self.birthDay = self.picker.date
        self.picker.addTarget(self, action: #selector(didSelect), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func didSelect(picker: UIDatePicker) {
        self.birthDay = picker.date
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        self.dobField.text = formatter.string(from: self.birthDay)
    }

    @IBAction func done() {
        self.birthDay = self.picker.date
        self.dobField.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func userExistsCheck(firstName: String, lastName: String) {
        let name = String(format: "%@ %@", firstName, lastName)
        self.userExists = RestAPI.getInstance().doesUserExist(withName: name)
    }

}

extension RegistrationPersonalInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        if textField == self.dobField {
            self.birthDay = self.picker.date
        } else {
            if let firstName = self.firstField.text, let lastName = self.lastField.text {
                DispatchQueue.global().async {
                    self.userExistsCheck(firstName: firstName, lastName: lastName)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == firstField {
            lastField.becomeFirstResponder()
        }
        return false
    }
}
