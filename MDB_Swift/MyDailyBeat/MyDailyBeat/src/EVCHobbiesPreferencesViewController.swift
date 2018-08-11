//
//  EVCHobbiesPreferencesViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/29/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit
import API
import Toast_Swift
class EVCHobbiesPreferencesViewController: UITableViewController {

    var prefs: HobbiesPreferences!
    var firstTimePrefs: VervePreferences = VervePreferences()
    var endsegue = ""
    var api: RestAPI!
    override func viewDidLoad() {
        super.viewDidLoad()
        api = RestAPI.getInstance()
        self.tableView.register(ToggleTableViewCell.self, forCellReuseIdentifier: "ToggleCell")
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = backButton
        if UserDefaults.standard.bool(forKey: "IN_SETUP") {
            let nextButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(nextButtonAction))
            self.navigationItem.rightBarButtonItem = nextButton
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.setHidesBackButton(true, animated: false)
        } else {
            self.navigationItem.setHidesBackButton(false, animated: false)
        }
        self.navigationItem.title = "My Hobbies"
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x0097A4)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func nextButtonAction() {
        self.firstTimePrefs.hobbiesPreferences = self.prefs
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                UIApplication.shared.keyWindow?.makeToastActivity(ToastPosition.center)
            })
            let success: Bool = self.api.save(self.firstTimePrefs.userPreferences!, andMatchingPreferences: self.firstTimePrefs.matchingPreferences!)
            let success2 = self.api.save(self.firstTimePrefs.hobbiesPreferences!)
            DispatchQueue.main.async(execute: {() -> Void in
                UIApplication.shared.keyWindow?.hideToastActivity()
                if success && success2 {
                    if self.endsegue == "RegularUnwindSegue" {
                        self.navigationController?.setNavigationBarHidden(true, animated: true)
                    }
                    UserDefaults.standard.set(false, forKey: "IN_SETUP")
                    self.performSegue(withIdentifier: self.endsegue, sender: self)
                }
                else {
                    let alertController = UIAlertController(title: "Error saving preferences", message: "Please attempt to save your preferences again. If problems continue, please contact us.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        })
        
    }
    
    @objc func cancel() {
        self.performSegue(withIdentifier: "BackToPrefsSegue", sender: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HobbiesRefList.getInstance().list.keys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell", for: indexPath) as! ToggleTableViewCell
        let list = HobbiesRefList.getInstance()
        cell.textLabel?.text = list.list[indexPath.row + 1]!
        cell.update()
        cell.toggleSwitch.setOn(self.prefs.hobbies[indexPath.row + 1] ?? false, animated: true)
        cell.onToggle = {
            self.prefs.hobbies[indexPath.row + 1] = cell.toggleSwitch.isOn
        }

        // Configure the cell...

        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? EVCPreferencesViewController {
            dest.hobbiesPreferences = self.prefs
        }
    }
    

}
