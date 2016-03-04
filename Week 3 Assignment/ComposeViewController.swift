//
//  ComposeViewController.swift
//  Week 3 Assignment
//
//  Created by Corwin Crownover on 2/20/16.
//  Copyright © 2016 Corwin Crownover. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // FUNCTIONS
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
