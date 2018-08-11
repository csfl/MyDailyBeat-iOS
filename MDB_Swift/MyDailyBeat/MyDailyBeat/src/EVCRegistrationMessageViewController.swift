
//
//  EVCRegistrationMessageViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/19/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import API
class EVCRegistrationMessageViewController: UIViewController {

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var navBar: UINavigationBar!
    var message: String = ""
    var image: UIImage? = nil
    var index = 0
    var nextPage: (() -> ()) = {
        // empty by default
    }
    var previousPage: (() -> ()) = {
        
    }

    @IBAction func next(_ sender: Any) {
        self.nextPage()
    }
    
    @IBAction func previous(_ sender: Any) {
        self.previousPage()
    }
    
    override var nibName: String? {
        get {
            return "RegistrationMessageViewController"
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = self.message
        if let nonNil = self.image {
            self.imageView.image = nonNil
        }
        
    }

    
}
