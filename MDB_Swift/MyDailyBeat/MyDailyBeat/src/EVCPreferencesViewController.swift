
//
//  EVCPreferencesViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/23/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import AssetsLibrary
import Toast_Swift
import API
import FXForms
import RESideMenu
class EVCPreferencesViewController: UITableViewController {
    var api: RestAPI!
    var prefs: VervePreferences = VervePreferences()
    var userEdited = false
    var matchEdited = false
    var hobbyEdited = false
    var userPreferences: VerveUserPreferences!
    var matchingPreferences: VerveMatchingPreferences!
    var hobbiesPreferences: HobbiesPreferences!
    var unwindSegueID: String = "RegularUnwindSegue"
    var onSuccess: ((Bool, UIViewController) -> ()) = { (success, vc) in
        _ = vc.sideMenuViewController.contentViewController.navigationController?.popToRootViewController(animated: true)
    }
    var canSave: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        api = RestAPI.getInstance()
        self.retrievePrefs()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.navigationItem.title = "About Me"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func retrievePrefs() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                UIApplication.shared.keyWindow?.makeToastActivity(ToastPosition.center)
            })
            self.userPreferences = self.api.getUserPreferences()
            self.matchingPreferences = self.api.getMatchingPreferences()
            self.hobbiesPreferences = self.api.getHobbiesPreferencesForUser()
            if self.api.preferencesExistForUser() {
                self.prefs.userPreferences = self.userPreferences
                self.userEdited = true
            }
            
            if self.api.matchingPreferencesExistForUser() {
                self.prefs.matchingPreferences = self.matchingPreferences
                self.matchEdited = true
            }
            
            if self.api.hobbiesPreferencesExistForUser() {
                self.prefs.hobbiesPreferences = self.hobbiesPreferences
                self.hobbyEdited = true
            }
            DispatchQueue.main.async(execute: {() -> Void in
                UIApplication.shared.keyWindow?.hideToastActivity()
                self.reloadData()
            })
        })
    }
    
    func reloadData() {
        if self.prefs.userPreferences == nil || self.prefs.matchingPreferences == nil || self.prefs.hobbiesPreferences == nil {
            self.canSave = false
        } else {
            self.canSave = true
        }
        self.tableView.reloadData()
    }

    func submit() {
        if userEdited && matchEdited && hobbyEdited {
            DispatchQueue.global().async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    UIApplication.shared.keyWindow?.makeToastActivity(ToastPosition.center)
                })
                let success: Bool = self.api.save(self.prefs.userPreferences!, andMatchingPreferences: self.prefs.matchingPreferences!)
                let success2 = self.api.save(self.prefs.hobbiesPreferences!)
                DispatchQueue.main.async(execute: {() -> Void in
                    UIApplication.shared.keyWindow?.hideToastActivity()
                    if success && success2 {
                        if self.unwindSegueID == "RegularUnwindSegue" {
                            self.navigationController?.setNavigationBarHidden(true, animated: true)
                        }
                        UserDefaults.standard.set(false, forKey: "IN_SETUP")
                        self.performSegue(withIdentifier: self.unwindSegueID, sender: self)
                    }
                    else {
                        let alertController = UIAlertController(title: "Error saving preferences", message: "Please attempt to save your preferences again. If problems continue, please contact us.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            })
        } else if !userEdited {
            let alertController = UIAlertController(title: "First Time Setup Not Complete", message: "We need you to provide some information about who you are. Please press 'Who I Am'. If problems continue, please contact us.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else if !matchEdited {
            let alertController = UIAlertController(title: "First Time Setup Not Complete", message: "We need you to provide some information to help us match people to you in the MyFling and MyRelationships modules. Please press 'My Ideal Match (for MyFling and MyRelationships)'. If problems continue, please contact us.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "First Time Setup Not Complete", message: "We need you to provide some information about your hobbies. Please press 'My Hobbies'. If problems continue, please contact us.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func backToPrefs(sender: UIStoryboardSegue) {
        if sender.source is EVCUserPreferencesViewController {
            self.prefs.userPreferences = self.userPreferences
            self.userEdited = true
        } else if sender.source is EVCMatchingPreferencesViewController {
            self.matchEdited = true
            self.prefs.matchingPreferences = self.matchingPreferences
        } else {
            self.hobbyEdited = true
            self.prefs.hobbiesPreferences = self.hobbiesPreferences
        }
        self.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Who I Am"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "My Ideal Match (for MyFling and MyRelationships)"
            } else {
                cell.textLabel?.text = "My Hobbies"
            }
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.textLabel?.text = "Save"
            cell.accessoryType = .none
        }
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let segue: String
            if indexPath.row == 0 {
                segue = "UserPrefSegue"
            } else if indexPath.row == 1 {
                segue = "MatchingPrefSegue"
            } else {
                segue = "HobbyPrefSegue"
            }
            self.performSegue(withIdentifier: segue, sender: nil)
        } else {
            if self.canSave {
                self.submit()
            } else {
                let alert = UIAlertController(title: "Preferences are not complete.", message: "You have not completed entering all your preferences.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? EVCUserPreferencesViewController {
            dest.prefs = self.userPreferences
            dest.firstTimePrefs = self.prefs
            if UserDefaults.standard.bool(forKey: "IN_SETUP") {
                dest.endsegue = self.unwindSegueID
            }
        } else if let dest = segue.destination as? EVCMatchingPreferencesViewController {
            dest.prefs = self.matchingPreferences
            dest.firstTimePrefs = self.prefs
            if UserDefaults.standard.bool(forKey: "IN_SETUP") {
                dest.endsegue = self.unwindSegueID
            }
        } else if let dest = segue.destination as? EVCHobbiesPreferencesViewController {
            dest.prefs = self.hobbiesPreferences
            dest.firstTimePrefs = self.prefs
            if UserDefaults.standard.bool(forKey: "IN_SETUP") {
                dest.endsegue = self.unwindSegueID
            }
        }
    }
    
}
