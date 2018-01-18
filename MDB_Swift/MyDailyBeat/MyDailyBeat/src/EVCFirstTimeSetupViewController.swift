
//
//  EVCFirstTimeSetupViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 7/12/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
class EVCFirstTimeSetupViewController: UIViewController {
    var api: RestAPI!
    @IBOutlet var message: UILabel!
    @IBOutlet var nextButton: UIButton!

    @IBAction func next(_ sender: Any) {
        let prefs = VervePreferences()
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                UIApplication.shared.keyWindow?.makeToastActivity(ToastPosition.center)
            })
            prefs.userPreferences = self.api.getUserPreferences()
            prefs.matchingPreferences = self.api.getMatchingPreferences()
            prefs.hobbiesPreferences = self.api.getHobbiesPreferencesForUser()
            DispatchQueue.main.async(execute: {() -> Void in
                UIApplication.shared.keyWindow?.hideToastActivity()
                self.performSegue(withIdentifier: "PrefsSegue", sender: nil)
            })
        })
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        api = RestAPI.getInstance()
        self.message.text = "Please set your preferences on the following pages to take advantage of all the features of MyDailyBeat."
        UserDefaults.standard.set(true, forKey: "IN_SETUP")
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? EVCPreferencesViewController {
            dest.unwindSegueID = "ModalUnwindSegue"
        }
    }

    
}
