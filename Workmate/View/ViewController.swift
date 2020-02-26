//
//  ViewController.swift
//  Workmate
//
//  Created by gsiva on 25/2/20.
//  Copyright © 2020 gsiva. All rights reserved.
//

import UIKit
import CoreLocation

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
        
    @IBOutlet weak var progressViewBar: UIProgressView!
    
    @IBOutlet weak var progressView: UIView!
        
    @IBOutlet weak var clockInProgessLabel: UILabel!
    
    var timeSheetStateValue = Constants.TimeSheetState.clockIn
    
    var jobViewModel = JobViewModel()
    
    var timesheetViewModel = TimesheetViewModel()

    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJobInfoAndUpdateUI()
        // Do any additional setup after loading the view.
    }
    
    /// Get the job data from the api and update UI
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
                    self.showAlert(title: "Failed", message: "\(error)")
                }
            }
        }
    }
    
    /// Update the UI
    func updateUI() {
        positionLabbel.text = jobViewModel.positionName
        wageAmountLabel.text = jobViewModel.wageAmount
        wageTypeLabel.text = jobViewModel.wageType
        clientLabel.text = jobViewModel.companyName
        addressLabel.text = jobViewModel.address
        managerNameLabel.text = jobViewModel.managerName
        managerNumberLabel.attributedText = jobViewModel.contactNumber
        let defaults = UserDefaults.standard
        if let clockInTime = defaults.value(forKey: "clockInTime") {
            self.clockInLabel.text = clockInTime as? String ?? ""
            self.timeSheetStateValue = Constants.TimeSheetState.clockOut
            self.timesheetViewModel.timeSheetStateValue = Constants.TimeSheetState.clockOut
            self.clockInOutButton.setTitle("Clock Out", for: .normal)
        }
    }
    
    /// Show alert
    /// - Parameters:
    ///   - title: alert title
    ///   - message: alert message
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
        
    @IBAction func clockInOutButtonAction(_ sender: Any) {
        if timeSheetStateValue == Constants.TimeSheetState.clockIn {
            clockInProgessLabel.text = "Clocking In..."
        }
        else {
            clockInProgessLabel.text = "Clocking Out..."
        }

        progressView.isHidden = false
        var progress: Float = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            progress += 0.05
            self.progressViewBar.setProgress(progress, animated: true)
            if progress > 1 {
                timer.invalidate()
                self.progressViewBar.setProgress(0, animated: true)
                self.progressView.isHidden = true
                self.updateTimeSheet()
            }
        }
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        timer?.invalidate()
        progressView.isHidden = true
        progressViewBar.setProgress(0, animated: true)
    }
    
    /// Update Timesheet based on the clock in/out
    func updateTimeSheet() {
        self.activityIndicator.startAnimating()
        if timeSheetStateValue == Constants.TimeSheetState.clockIn {
            timesheetViewModel.getClockInInfo { [weak self] result in
                guard let self = self else {return}
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                
                switch result {
                case .success( _):
                    DispatchQueue.main.async {
                        self.clockInLabel.text = self.timesheetViewModel.clockInTime
                        self.timeSheetStateValue = Constants.TimeSheetState.clockOut
                        self.timesheetViewModel.timeSheetStateValue = self.timeSheetStateValue
                        self.clockInOutButton.setTitle("Clock Out", for: .normal)
                        let defaults = UserDefaults.standard
                        defaults.set(self.timesheetViewModel.clockInTime, forKey: "clockInTime")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(title: "Failed", message: "\(error)")
                    }
                }
            }
        } else {
            timesheetViewModel.getClockOutInfo { [weak self] result in
                guard let self = self else {return}
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                
                switch result {
                case .success( _):
                    DispatchQueue.main.async {
                        self.clockOutLabel.text = self.timesheetViewModel.clockOutTime
                        self.clockInOutButton.isHidden = true
                        let defaults = UserDefaults.standard
                        defaults.set(nil, forKey: "clockInTime")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(title: "Failed", message: "\(error)")
                    }
                }
            }
        }
    }
}
