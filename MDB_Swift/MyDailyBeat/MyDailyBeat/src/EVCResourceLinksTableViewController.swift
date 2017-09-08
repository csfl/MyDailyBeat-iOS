
//
//  EVCResourceLinksTableViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/30/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import UIKit
import API
import SwiftyJSON

fileprivate let RESOURCE_LINKS: [String: [String]] = [
    "Finance": ["finance.yahoo.com", "money.cnn.com", "bloomberg.com"],
    "FeelingBlue": ["suicidepreventionlifeline.org", "psychcentral.com/helpme.htm", "hopeline.com", "https://www.amazon.com/dp/B06W59GGMH?psc=1"],
    "Jobs": ["livecareer.com", "careerservices.princeton.edu"],
    "Health": ["webmd.com", "mayoclinic.org", "cdc.gov", "medicineonline.com", "online-medical-dictionary.org", "https://www.amazon.com/Feeling-Good-New-Mood-Therapy-ebook/dp/B009UW5X4C/ref=sr_1_7?ie=UTF8&qid=1502650556&sr=8-7&keywords=relationships", "https://www.amazon.com/TENDLITE-Sufferers-Arthritis-Neuropathy-Tendonitis/dp/B004QECAU4/ref=sr_1_11_a_it?ie=UTF8&qid=1502668470&sr=8-11&keywords=medical+devices"],
    "Relationships": ["https://www.amazon.com/dp/B00OICLVBI?psc=1", "https://www.amazon.com/Dating-21-century-companion-happiness-ebook/dp/B00T8JL8B4/ref=sr_1_10?s=digital-text&ie=UTF8&qid=1502669309&sr=1-10&keywords=relationships+for+older+adults"],
    "Fling": ["https://www.amazon.com/s/ref=nb_sb_noss_2?url=search-alias%3Ddigital-text&field-keywords=the+art+of+seduction", "https://www.amazon.com/Intimacy-Kit-Future-Safe-Sex/dp/B00AV0D6SW/ref=sr_1_5_a_it?ie=UTF8&qid=1502652572&sr=8-5&keywords=safe+sex+kits", "https://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=lingerie+for+older+women", "https://www.amazon.com/Bunnyjuice-Wildbunny-Intimacy-Love-4her/dp/B06XPXJWZ5/ref=pd_sbs_121_1?_encoding=UTF8&pd_rd_i=B06XPXJWZ5&pd_rd_r=MCNW5KKQ0GHTY2CS7CJS&pd_rd_w=W0y2a&pd_rd_wg=DDgf8&psc=1&refRID=MCNW5KKQ0GHTY2CS7CJS"],
    "Friends": ["https://www.amazon.com/b/ref=nav_cs_gc_registry?ie=UTF8&node=14069511011", "https://www.amazon.com/Lifestyle-Home-Hobby-Subscription-Services/b/ref=sd_allcat?ie=UTF8&node=14498700011", "https://www.amazon.com/Stop-Being-Lonely-Friendships-Relationships-ebook/dp/B01AYT3LZW/ref=pd_rhf_se_s_fbcp_sp_2?_encoding=UTF8&pd_rd_i=B01AYT3LZW&pd_rd_r=VMPE6N2367W0F0HZ6R08&pd_rd_w=PAUB9&pd_rd_wg=KpysZ&pf_rd_i=desktop-rhf&pf_rd_m=ATVPDKIKX0DER&pf_rd_p=3150073222&pf_rd_r=VMPE6N2367W0F0HZ6R08&pf_rd_s=desktop-rhf&pf_rd_t=40701&psc=1&refRID=VMPE6N2367W0F0HZ6R08"],
    "Shopping": ["https://www.amazon.com/Subscribe-Save/b/ref=sd_allcat_subscribe_save?ie=UTF8&node=5856181011", "https://www.amazon.com/s/ref=nb_sb_noss_2?url=search-alias%3Daps&field-keywords=medical+devices", "https://www.amazon.com/b/ref=nav_cs_gc_registry?ie=UTF8&node=14069511011"],
    "Travel": ["travelchannel.com", "cnn.com/travel", "forbestravelguide.com", "tripadvisor.com"],
    "Volunteering": ["signup.com", "agingnetworkvolunteercollaborative.org", "communityservice.org", "retiredbrains.com/senior-living-resources/volunteering"]
]

fileprivate let RESOURCE_TITLES: [String: [String]] = [
    "Finance": ["finance.yahoo.com", "money.cnn.com", "bloomberg.com"],
    "FeelingBlue": ["suicidepreventionlifeline.org", "psychcentral.com/helpme.htm", "hopeline.com", "50 Steps to Freedom: A personal journey from Depression to Joy: The Mindful Way"],
    "Jobs": ["livecareer.com", "careerservices.princeton.edu"],
    "Health": ["webmd.com", "mayoclinic.org", "cdc.gov", "medicineonline.com", "online-medical-dictionary.org", "Feeling Good: The Mood Therapy", "Tendlite Red Light Device Joint & Muscle Pain Reliever"],
    "Relationships": ["The 5 Languages of Love: The Secret to Love that Lasts", "Dating in the 21st Century: Are older single adults able to find success in locating a companion and increase the happiness in their lives"],
    "Fling": ["The Art of Seduction", "Intimacy Kit - Safe Sex Kit", "Sexy lingerie", "Bunny Juice Love Kit"],
    "Friends": ["Gift Cards", "Hobbies/Arts/Crafts Groups", "Stop Being Lonely: 3 Simple Steps to Developing Close Friendships and Deep Relationships"],
    "Shopping": ["Subscribe and Save", "Various medical and safety prodcuts", "Gift Cards"],
    "Travel": ["travelchannel.com", "cnn.com/travel", "forbestravelguide.com", "tripadvisor.com"],
    "Volunteering": ["signup.com", "agingnetworkvolunteercollaborative.org", "communityservice.org", "retiredbrains.com/senior-living-resources/volunteering"]
]


class EVCResourceLinksTableViewController: UITableViewController {
    var module: String = ""
    var resLinks = [String]()
    var resTitles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let insets: UIEdgeInsets? = UIEdgeInsetsMake(0, 0, (self.tabBarController?.tabBar.frame.height)!, 0)
        self.tableView.contentInset = insets!
        self.tableView.scrollIndicatorInsets = insets!
        self.edgesForExtendedLayout = .all
        self.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.keyWindow?.makeToastActivity(.center)
        self.reloadData()
        UIApplication.shared.keyWindow?.hideToastActivity()
    }

    func reloadData() {
        self.resLinks = RESOURCE_LINKS[self.module] ?? [String]()
        self.resTitles = RESOURCE_TITLES[self.module] ?? self.resLinks
        self.tableView.reloadData()
    }

    
// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.resLinks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        if self.resLinks.isEmpty {
            cell.textLabel?.text = "No Links Found"
        }
        else {
            cell.textLabel?.text = self.resTitles[indexPath.row]
        }
        return cell
    }
// MARK: - Table view delegate
    // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.resLinks.count > 0 {
            if self.module == "Jobs" && indexPath.row == 1 {
                self.openURLinBrowser(self.resLinks[indexPath.row], useWWW: false)
            } else {
                self.openURLinBrowser(self.resLinks[indexPath.row])
            }
            
        }
    }

    func openURLinBrowser(_ url: String, useWWW: Bool = true) {
        let fullURL: String
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            fullURL = "\(url)"
        } else if useWWW {
            fullURL = "https://www.\(url)"
        } else {
            fullURL = "https://\(url)"
        }
        UIApplication.shared.open(URL(string: fullURL)!, options: [:], completionHandler: nil)
    }
}
