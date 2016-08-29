//
//  AdjustableTableViewController.swift
//  Recover
//
//  Created by Ryan Cortez on 8/29/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class AdjustableTableViewController: BasicTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        self.tableView.estimatedRowHeight = 88.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
