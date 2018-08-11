
//
//  EVCFinanceViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/29/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import UIKit
import RESideMenu
import SwiftDispatchOnce
class EVCFinanceViewController: EVCTabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(to: "Check my Finances")
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let message = "Step 1:\nAdd your financial institution.\n\nClick on \"Search\" to find your financial institution or enter its name.\n\nStep 2:\nSelect “Set as My Bank” if adding for the first time.\n\nSelect \"Open Your Bank’s App\" if it already exists.\n\nStep 3:\nReturn to MyDailyBeat by clicking breadcrumb at top left \"MyDailyBeat.\""
        let alert = UIAlertController(title: "How to \"Check My Finances\"", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let dest = viewController as? EVCResourceLinksTableViewController {
            dest.module = "Finance"
        }
    }
    

    
}
