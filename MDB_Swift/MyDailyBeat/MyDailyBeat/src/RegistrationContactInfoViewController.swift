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

class RegistrationContactInfoViewController: UIViewController {
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var mobileField: UITextField!
    @IBOutlet var zipField: UITextField!
    @IBOutlet var emailOuter: UITextField!
    @IBOutlet var mobileOuter: UITextField!
    @IBOutlet var zipOuter: UITextField!
    var userWithEmailExists = false
    var userWithMobileExists = false
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
        guard isValidInput else {
            // TODO: Show error messages here.
            if !allFieldsFilledIn {
                self.makeAlert(with: "Form not complete.", and: "One or more of the fields on this page are not filled in. Please enter valid input for all the fields on this page.")
            } else if userWithEmailExists {
                self.makeAlert(with: "User Already Exists", and: "A user with this email address already exists. Please select a different email address.")
            } else {
                self.makeAlert(with: "User Already Exists", and: "A user with this mobile phone number already exists. Please select a different mobile phone number.")
            }
            return
        }
        let obj = RegistrationObject.getInstance()
        obj.email = emailField.text!
        obj.mobile = mobileField.text!
        obj.zipcode = zipField.text!
        RegistrationObject.updateInstance(modified: obj)
        self.nextPage()
    }
    
    var isValidInput: Bool {
        let result = !(userWithEmailExists || userWithMobileExists)
        guard allFieldsFilledIn else {
            return false
        }
        
        return result
    }
    
    var allFieldsFilledIn: Bool {
        var result = false
        if let _ = self.emailField.text, let _ = self.mobileField.text, let _ = self.zipField.text {
            result = true
        }
        return result
    }
    
    override var nibName: String? {
        get {
            return "RegistrationContactInfoViewController"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.delegate = self
        self.mobileField.delegate = self
        self.zipField.delegate = self
        self.emailOuter.delegate = DisableOuterField()
        self.mobileOuter.delegate = DisableOuterField()
        self.zipOuter.delegate = DisableOuterField()
        self.emailField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.zipField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.mobileField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.emailOuter.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.mobileOuter.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.zipOuter.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        self.emailOuter.layer.borderColor = UIColor.white.cgColor
        self.emailOuter.layer.borderWidth = 2
        self.emailOuter.layer.cornerRadius = 8
        self.emailOuter.clipsToBounds = true
        self.mobileOuter.layer.borderColor = UIColor.white.cgColor
        self.mobileOuter.layer.borderWidth = 2
        self.mobileOuter.layer.cornerRadius = 8
        self.mobileOuter.clipsToBounds = true
        self.zipOuter.layer.borderColor = UIColor.white.cgColor
        self.zipOuter.layer.borderWidth = 2
        self.zipOuter.layer.cornerRadius = 8
        self.zipOuter.clipsToBounds = true
        
        emailField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName: UIColor(netHex: 0x0097A4)])
        mobileField.attributedPlaceholder = NSAttributedString(string: "Mobile Phone #", attributes: [NSForegroundColorAttributeName: UIColor(netHex: 0x0097A4)])
        zipField.attributedPlaceholder = NSAttributedString(string: "Zip Code", attributes: [NSForegroundColorAttributeName: UIColor(netHex: 0x0097A4)])
        // Do any additional setup after loading the view.
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

}

extension RegistrationContactInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        if textField == self.emailField {
            if let email = self.emailField.text {
                DispatchQueue.global().async {
                    DispatchQueue.main.sync {
                        UIApplication.shared.keyWindow?.makeToastActivity(.center)
                    }
                    self.userWithEmailExists = RestAPI.getInstance().doesUserExist(withEmail: email)
                    DispatchQueue.main.sync {
                        UIApplication.shared.keyWindow?.hideToastActivity()
                    }
                }
            }
        } else if textField == self.mobileField {
            if let mobile = self.mobileField.text {
                DispatchQueue.global().async {
                    DispatchQueue.main.sync {
                        UIApplication.shared.keyWindow?.makeToastActivity(.center)
                    }
                    self.userWithMobileExists = RestAPI.getInstance().doesUserExist(withMobile: mobile)
                    DispatchQueue.main.sync {
                        UIApplication.shared.keyWindow?.hideToastActivity()
                    }
                }
            }
        } else {
            // do nothing
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailField {
            mobileField.becomeFirstResponder()
        } else if textField == mobileField {
            zipField.becomeFirstResponder()
        }
        return false
    }
}
