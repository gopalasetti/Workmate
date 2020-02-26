//
//  NetworkService.swift
//  Workmate
//
//  Created by gsiva on 25/2/20.
//  Copyright © 2020 gsiva. All rights reserved.
//

import Foundation

class APIService {
    
    private var apiKey = ""
    
    var baseURL: URL? = nil
    
    private let urlSession = URLSession.shared
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
        
    static let shared = APIService()
    
    init (){
        self.baseURL = URL(string: Constants.serviceBaseURL)
    }
        
    
    /// Fetch the data from the server
    /// - Parameters:
    ///   - request: url request object
    ///   - completion: will return with the response and error if any
    private func fetchResources<T:Decodable>(request: URLRequest, completion: @escaping (Result<T, APIServiceError>) -> ()) {
        
        urlSession.dataTask(with: request) { (data, response, error) in
            if error != nil || data == nil {
                completion(.failure(.invalidResponse))
            }
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print(jsonObject)
                let values = try self.jsonDecoder.decode(T.self, from: data!)
                completion(.success(values))
            } catch {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
    
    
    /// Login aPI cal
    /// - Parameters:
    ///   - username: username value
    ///   - password: password value
    ///   - result: reurns the Login model on success
    func login(username: String = "+6281313272005", password: String = "alexander", result: @escaping (Result<Login, APIServiceError>) -> ()) {
        guard let loginUrl = baseURL?.appendingPathComponent(Constants.ServiceEndPoint.login.rawValue) else {
            result(.failure(.invalidEndpoint))
            return
        }
        
        var postBody = [String: String]()
        postBody["username"] = username
        postBody["password"] = password
        do {
            let data = try JSONSerialization.data(withJSONObject: postBody, options: [])
            var request = URLRequest(url: loginUrl)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            fetchResources(request: request, completion: result)
        }
        catch {
            result(.failure(.invalidEndpoint))
        }
    }
    
    /// Get the job detals
    /// - Parameter result: returns the job model object on success
    func getJobInfo(result: @escaping (Result<Job, APIServiceError>) -> ()) {
        guard let jobUrl = baseURL?.appendingPathComponent(Constants.ServiceEndPoint.job.rawValue) else {
            result(.failure(.invalidEndpoint))
            return
        }
        
        var request = URLRequest(url: jobUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        fetchResources(request: request, completion: result)
    }
    
    /// Clock in time service
    /// - Parameters:
    ///   - latitude: Lattitude, Setting defsult values
    ///   - longitude: longitude , we set as default value
    ///   - result: returns the clock in time object
    func clockInTimesheet(latitude: String = "-6.2446691", longitude: String = "106.8779625", result: @escaping (Result<ClockInTimeSheet, APIServiceError>) -> ()) {
        guard let clockInUrl = baseURL?.appendingPathComponent(Constants.ServiceEndPoint.clockIn.rawValue) else {
            result(.failure(.invalidEndpoint))
            return
        }
        
        var postBody = [String: String]()
        postBody["latitude"] = latitude
        postBody["longitude"] = longitude
        do {
            let data = try JSONSerialization.data(withJSONObject: postBody, options: [])
            var request = URLRequest(url: clockInUrl)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("token \(apiKey)", forHTTPHeaderField: "Authorization")
            fetchResources(request: request, completion: result)
        }
        catch {
            result(.failure(.invalidEndpoint))
        }
    }
    
    /// clock out time service
    /// - Parameters:
    ///   - latitude: Lattitude, Setting defsult values
    ///   - longitude: longitude , we set as default value
    ///   - result: returns the clock out time object
    func clockOutTimesheet(latitude: String = "-6.2446691", longitude: String = "106.8779625", result: @escaping (Result<ClockOutTimeSheet, APIServiceError>) -> ()) {
        guard let clockOutUrl = baseURL?.appendingPathComponent(Constants.ServiceEndPoint.clockOut.rawValue) else {
            result(.failure(.invalidEndpoint))
            return
        }
        
        var postBody = [String: String]()
        postBody["latitude"] = latitude
        postBody["longitude"] = longitude
        do {
            let data = try JSONSerialization.data(withJSONObject: postBody, options: [])
            var request = URLRequest(url: clockOutUrl)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("token \(apiKey)", forHTTPHeaderField: "Authorization")
            fetchResources(request: request, completion: result)
        }
        catch {
            result(.failure(.invalidEndpoint))
        }
    }
    
    /// Set apikey to the property
    /// - Parameter key: apikey
    func setApiKey(with key: String) {
        self.apiKey = key
    }
    
}

public enum APIServiceError: Error {
    case invalidEndpoint
    case invalidResponse
    case decodeError
}
