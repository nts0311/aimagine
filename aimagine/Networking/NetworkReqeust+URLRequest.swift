//
//  NetworkReqeust+URLRequest.swift
//  AutoPancake
//
//  Created by son on 01/07/2023.
//

import Foundation

extension NetworkRequest {
    
    func getUrlComponents(string: String) -> URLComponents? {
        guard var components = URLComponents(string: string) else {
            return nil
        }
        
        components.queryItems = queryParams.map { (key, value) in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        return components
    }
    
    func createBaseURLRequest(with baseURL: String) -> URLRequest? {
        guard let components = getUrlComponents(string: "\(baseURL)\(path)"),
              let url = components.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = type.strValue
        
        header.forEach { (header, value) in
            urlRequest.addValue("\(value)", forHTTPHeaderField: header)
        }
        
        return urlRequest
    }
    
    func createGetURLRequest(with baseURL: String) -> URLRequest? {
        return createBaseURLRequest(with: baseURL)
    }
}

extension NetworkRequest {
    func createPostFormURLRequest(with baseURL: String) -> URLRequest? {
        guard let components = getUrlComponents(string: "\(baseURL)\(path)"),
              let url = components.url else {
            return nil
        }
        
        let multipartRequest = MultipartFormRequest(url: url, fields: multipartForm ?? [])
        
        return multipartRequest.asURLRequest()
    }
}

extension NetworkRequest {
    func createPostJson(with baseURL: String) -> URLRequest? {
        var urlRequest = createBaseURLRequest(with: baseURL)
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonBody {
            let jsonData = try? jsonEncoder.encode(jsonBody)
            
            urlRequest?.httpBody = jsonData
            
            urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest?.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        }
    
        
        return urlRequest
    }
}
