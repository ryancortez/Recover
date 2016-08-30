//
//  SettingsTableViewController.swift
//  Lists
//
//  Created by Ryan Cortez on 8/10/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var userHasTipped = true
    //    var cloudKitManager = CloudKitManager()
    
    override func viewDidLoad() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
    }
    
    // MARK: - TableView Data Source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if userHasTipped {
            return 3
        } else {
            return 2
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userHasTipped {
            switch section {
            case 0: return 1
            case 1: return 2
            case 2: return 2
            default: return 0
            }
        } else {
            switch section {
            case 0: return 1
            case 1: return 2
            default: return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if userHasTipped {
            switch indexPath.section {
            case 0: return tableView.dequeueReusableCellWithIdentifier("feedbackCell") ?? UITableViewCell(style: .Default, reuseIdentifier: "feedbackCell")
            case 1: if (indexPath.row == 0) {
                return tableView.dequeueReusableCellWithIdentifier("tipCell") ?? UITableViewCell(style: .Default, reuseIdentifier: "tipCell")
            } else {
                return tableView.dequeueReusableCellWithIdentifier("restorePurchasesCell") ?? UITableViewCell(style: .Default, reuseIdentifier: "restorePurchasesCell")
                }
            case 2: if (indexPath.row == 0) {
                return tableView.dequeueReusableCellWithIdentifier("backupCell") ?? UITableViewCell(style: .Default, reuseIdentifier: "backupCell")
            } else {
                return tableView.dequeueReusableCellWithIdentifier("replaceListsCell") ?? UITableViewCell(style: .Default, reuseIdentifier: "replaceListsCell")
                }
            default: return UITableViewCell()
            }
        } else {
            switch indexPath.section {
            case 0: return tableView.dequeueReusableCellWithIdentifier("feedbackCell") ?? UITableViewCell(style: .Default, reuseIdentifier: "feedbackCell")
            case 1: if (indexPath.row == 0) {
                return tableView.dequeueReusableCellWithIdentifier("tipCell") ?? UITableViewCell(style: .Default, reuseIdentifier: "tipCell")
            } else {
                return tableView.dequeueReusableCellWithIdentifier("restorePurchasesCell") ?? UITableViewCell(style: .Default, reuseIdentifier: "restorePurchasesCell")
                }
            default: return UITableViewCell()
            }
        }
    }
    
    
    // MARK: - Compose Email
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        let appName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as? String ?? "Lists"
        let appVersion = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
        mailComposerVC.setToRecipients(["feedback@fullscreenahead.co"])
        mailComposerVC.setSubject("Feedback for \(appName) (\(appVersion))")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlertController = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again. Check your iPhone's Settings > Mail, Contacts, and Calendar", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        sendMailErrorAlertController.addAction(OKAction)
        
        presentViewController(sendMailErrorAlertController, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK: - Actions
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func feedbackButtonPressed(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    @IBAction func backupToiCloudButtonPressed(sender: AnyObject) {
        //        let lists = UserDefaultsManager.fetchListsFromNSUserDefaults()
        
    }
    @IBAction func replaceListsButtonPressed(sender: AnyObject) {
        //        cloudKitManager.fetchAllLists()
        //        let lists = cloudKitManager.lists
        //        print(lists)
    }
    @IBAction func smallTipButtonPressed(sender: AnyObject) {
    }
    @IBAction func mediumTipButtonPressed(sender: AnyObject) {
    }
    @IBAction func largeTipButtonPressed(sender: AnyObject) {
    }
    @IBAction func restorePurchasesButtonPressed(sender: AnyObject) {
    }
}
