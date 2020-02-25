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
        
    private func fetchResources<T:Decodable>(request: URLRequest, completion: @escaping (Result<T, APIServiceError>) -> ()) {
        
        urlSession.dataTask(with: request) { (data, response, error) in
            if error != nil || data == nil {
                completion(.failure(.invalidResponse))
            }
            do {
                let values = try self.jsonDecoder.decode(T.self, from: data!)
                completion(.success(values))
            } catch {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
    
    
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
            request.setValue(apiKey, forHTTPHeaderField: "Authorization")
            fetchResources(request: request, completion: result)
        }
        catch {
            result(.failure(.invalidEndpoint))
        }
    }
    
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
            request.setValue(apiKey, forHTTPHeaderField: "Authorization")
            fetchResources(request: request, completion: result)
        }
        catch {
            result(.failure(.invalidEndpoint))
        }
    }
    
    func setApiKey(with key: String) {
        self.apiKey = key
    }
    
}

public enum APIServiceError: Error {
    case invalidEndpoint
    case invalidResponse
    case decodeError
}
