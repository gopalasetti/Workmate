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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var clockInOutButton: ClockInOutButton!
    
    var jobViewModel = JobViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJobInfoAndUpdateUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clockInOutButtonAction(_ sender: Any) {
        
    }
    
    func getJobInfoAndUpdateUI() {
        jobViewModel.getJobInfo { [weak self] result in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    self.updateUI()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Failed", message: "\(error)", viewController: self)
                }
            }
        }
    }
    
    func updateUI() {
        positionLabbel.text = jobViewModel.positionName
        wageAmountLabel.text = jobViewModel.wageAmount
        wageTypeLabel.text = jobViewModel.wageType
        clientLabel.text = jobViewModel.companyName
        addressLabel.text = jobViewModel.address
        managerNameLabel.text = jobViewModel.managerName
        managerNumberLabel.attributedText = jobViewModel.contactNumber
    }
    
    func showAlert(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        viewController.present(alert, animated: true, completion: nil)
    }
    
}

