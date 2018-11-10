
//
//  EVCFlingViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import API
import DLAlertView
import GBVersionTracking
class EVCFlingViewController: EVCTabBarController, UITabBarControllerDelegate {
    var mode: REL_MODE = .friends_MODE
    var profCreated: Bool = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var title: String = ""
        switch self.mode {
            case .friends_MODE:
                title = "Make Friends"
            case .fling_MODE:
                title = "Have a Fling"
            case .relationship_MODE:
                title = "Start a Relationship"
        }

        self.setNavTitle(to: title)
        self.doesProfExist()
        if GBVersionTracking.isFirstLaunchEver() && !self.profCreated {
            self.flingProf()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func doesProfExist() {
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                UIApplication.shared.keyWindow?.makeToastActivity(.center)
            })
            let profile: FlingProfile
            if self.mode == .fling_MODE {
                profile = RestAPI.getInstance().getFlingProfile(for: RestAPI.getInstance().getCurrentUser())
            } else if self.mode == .relationship_MODE {
                profile = RestAPI.getInstance().getRelationshipProfile(for: RestAPI.getInstance().getCurrentUser())
            } else {
                profile = RestAPI.getInstance().getFriendsProfile(for: RestAPI.getInstance().getCurrentUser())
            }
            if profile.id == 0 {
                self.profCreated = false
            } else {
                self.profCreated = true
            }
            DispatchQueue.main.async(execute: {() -> Void in
                UIApplication.shared.keyWindow?.hideToastActivity()
            })
        })
    }

    func flingProf() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                let alert = UIAlertController(title: "Create your Profile", message: "To fully enjoy all the features of MyDailyBeat, you need to create a relationship profile. This unified profile is used across the Have a Fling, Start a Relationship, and Make Friends sections of this app.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: "EditProfileSegue", sender: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: {
                    self.profCreated = true
                })
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? EVCFlingProfileCreatorViewController {
            dest.mode = self.mode
            dest.isModal = true
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let dest = viewController as? EVCPartnerMatchViewController {
            dest.mode = self.mode
        } else if let dest = viewController as? EVCPartnersTableViewController {
            dest.mode = self.mode
        } else if let dest = viewController as? EVCFlingProfileViewController {
            dest.mode = self.mode
            dest.currentViewedUser = RestAPI.getInstance().getCurrentUser()
        } else if let dest = viewController as? EVCResourceLinksTableViewController {
            let module: String
            switch self.mode {
            case .friends_MODE:
                module = "Friends"
            case .fling_MODE:
                module = "Fling"
            case .relationship_MODE:
                module = "Relationships"
            }
            dest.module = module
        }
    }
}
