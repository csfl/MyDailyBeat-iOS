//
//  EVCHobbiesPreferencesViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/29/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit
import API
class EVCHobbiesPreferencesViewController: UITableViewController {

    var prefs: HobbiesPreferences!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ToggleTableViewCell.self, forCellReuseIdentifier: "ToggleCell")
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = backButton
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        label.text = "Press Back to Proceed"
        label.textColor = UIColor.gray
        label.sizeToFit()
        label.textAlignment = .center
        label.frame.size.width = self.view.frame.width
        label.frame.size.height *= 2
        self.tableView.tableHeaderView = label
    }
    
    func cancel() {
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
        cell.toggleSwitch.setOn(self.prefs.hobbies[indexPath.row + 1]!, animated: true)
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
