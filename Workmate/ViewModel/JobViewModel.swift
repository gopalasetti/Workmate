//
//  JobViewModel.swift
//  Workmate
//
//  Created by gsiva on 25/2/20.
//  Copyright © 2020 gsiva. All rights reserved.
//

import Foundation
import UIKit

class JobViewModel: ObservableObject {
    
    var job: Job?
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var positionName : String {
        return job?.positionName ?? ""
    }
    
    var wageAmount: String {
        let payAmount = Double(job!.wageAmount) ?? 0
        let wage = Int(payAmount)
        return "Rp " + formatter.string(from: NSNumber(value: wage))!
    }
    
    var wageType: String {
        let payType = job?.wageType ?? ""
        return payType.replacingOccurrences(of: "_", with: " ")
    }
    
    var companyName: String {
        return job?.clientName ?? ""
    }
    
    var address: String {
        return job?.address ?? ""
    }
    
    var managerName: String {
        return job?.managerName ?? ""
    }
    
    var contactNumber: NSAttributedString {
        let number = job?.managerNumber ?? ""
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        return NSAttributedString(string: number, attributes: underlineAttribute)
    }
    
    typealias Handler<T>  = (Result<T, Error>) -> Void
    
    init() {}
    
    /// Get the job details
    /// - Parameter completion: return with Job object
    func getJobInfo(completion: @escaping Handler<Job>) {
        APIService.shared.login { [weak self] (result) in
            switch result {
            case .success(let response):
                APIService.shared.setApiKey(with: response.key)
                APIService.shared.getJobInfo { [weak self] (result) in
                    guard let self = self else {return}
                    
                    switch result {
                    case .success(let results):
                        self.job = results
                        completion(.success(self.job!))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
