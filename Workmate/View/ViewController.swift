//
//  ViewController.swift
//  Workmate
//
//  Created by gsiva on 25/2/20.
//  Copyright © 2020 gsiva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var positionLabbel: UILabel!
    @IBOutlet weak var clientLabel: UILabel!
    
    @IBOutlet weak var wageAmountLabel: UILabel!
    @IBOutlet weak var wageTypeLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var managerNameLabel: UILabel!
    @IBOutlet weak var managerNumberLabel: UILabel!
    
    @IBOutlet weak var clockInLabel: UILabel!
    @IBOutlet weak var clockOutLabel: UILabel!
    
    @IBOutlet weak var clockInOutButton: ClockInOutButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clockInOutButtonAction(_ sender: Any) {
        
    }
    
}

