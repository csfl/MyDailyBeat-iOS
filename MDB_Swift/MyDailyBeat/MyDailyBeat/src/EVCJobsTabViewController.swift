
//
//  EVCJobsTabViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/27/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import RESideMenu
class EVCJobsTabViewController: EVCTabBarController, UITabBarControllerDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(to: "Find a Job")
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let message = "Simply click on the \"Job Search\" icon below to start your search."
        let alert = UIAlertController(title: "How to \"Find a Job\"", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let dest = viewController as? EVCResourceLinksTableViewController {
            dest.module = "Jobs"
        }
    }

    

}
