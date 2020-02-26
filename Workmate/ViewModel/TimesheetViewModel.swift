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

    func getDate(serverDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZ"
        let date = dateFormatter.date(from: serverDateString)!
        dateFormatter.dateFormat = "h:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
