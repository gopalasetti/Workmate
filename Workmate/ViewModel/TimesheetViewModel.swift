//
//  TimesheetViewModel.swift
//  Workmate
//
//  Created by gsiva on 25/2/20.
//  Copyright © 2020 gsiva. All rights reserved.
//

import Foundation
import CoreLocation

class TimesheetViewModel: ObservableObject {
    
    var clockIn: ClockInTimeSheet?
    var clockOut: ClockOutTimeSheet?

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var timeSheetStateValue = Constants.TimeSheetState.clockIn

    var clockInTime : String {
        let date = clockIn?.clockInTime ?? ""
        return getDate(serverDateString: date)
    }
    
    var clockOutTime : String {
        let date = clockOut?.clockOutTime ?? ""
        return getDate(serverDateString: date)
    }
    
    typealias Handler<T>  = (Result<T, Error>) -> Void
    
    init() {}
    
    /// Get clock in info
    /// - Parameter completion: Returns the ClockinTimeSheet
    func getClockInInfo(completion: @escaping Handler<ClockInTimeSheet>) {
        APIService.shared.clockInTimesheet { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let results):
                self.clockIn = results
                completion(.success(self.clockIn!))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Get clock out info
    /// - Parameter completion: Return eith ClockOutTimeSheet Object
    func getClockOutInfo(completion: @escaping Handler<ClockOutTimeSheet>) {
        APIService.shared.clockOutTimesheet { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let results):
                self.clockOut = results
                completion(.success(self.clockOut!))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Get date fromat in hours and minits from dte string
    /// - Parameter serverDateString: returns the date string (h:mm a) format
    func getDate(serverDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZ"
        let date = dateFormatter.date(from: serverDateString)!
        dateFormatter.dateFormat = "hh:mma"
        let dateString = dateFormatter.string(from: date)
        return dateString.lowercased()
    }
}
