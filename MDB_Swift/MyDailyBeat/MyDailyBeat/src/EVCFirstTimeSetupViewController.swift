
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
    let prefs = VervePreferences()

    @IBAction func next(_ sender: Any) {
        UIApplication.shared.keyWindow?.hideAllToasts(includeActivity: true, clearQueue: true)
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                UIApplication.shared.keyWindow?.makeToastActivity(ToastPosition.center)
            })
            self.prefs.userPreferences = self.api.getUserPreferences()
            self.prefs.matchingPreferences = self.api.getMatchingPreferences()
            self.prefs.hobbiesPreferences = self.api.getHobbiesPreferencesForUser()
            DispatchQueue.main.async(execute: {() -> Void in
                UIApplication.shared.keyWindow?.hideToastActivity()
                self.performSegue(withIdentifier: "UserPreferencesSegue", sender: nil)
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
        if let dest = segue.destination as? EVCUserPreferencesViewController {
            dest.prefs = self.prefs.userPreferences
            dest.firstTimePrefs = self.prefs
            if UserDefaults.standard.bool(forKey: "IN_SETUP") {
                dest.endsegue = "LoginSegue"
            }
        } else if let dest = segue.destination as? EVCMatchingPreferencesViewController {
            dest.prefs = self.prefs.matchingPreferences
            dest.firstTimePrefs = self.prefs
            if UserDefaults.standard.bool(forKey: "IN_SETUP") {
                dest.endsegue = "LoginSegue"
            }
        } else if let dest = segue.destination as? EVCHobbiesPreferencesViewController {
            dest.prefs = self.prefs.hobbiesPreferences
            dest.firstTimePrefs = self.prefs
            if UserDefaults.standard.bool(forKey: "IN_SETUP") {
                dest.endsegue = "LoginSegue"
            }
        }
    }

    
}
