//
//  DisclamierViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/30/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class DisclamierViewController: UIViewController {

    @IBAction func agreeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
