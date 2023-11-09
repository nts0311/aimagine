//
//  ApiManager.swift
//  AutoPancake
//
//  Created by son on 01/07/2023.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
}

class ApiManager {
    //var baseURL = "https://pages.fm/api"
    static let shared = ApiManager()
    private init() {}
    
    func request<T: Decodable>(with request: NetworkRequest) async throws -> T {
        guard let urlRequest = request.getUrlRequest(baseURL: baseURL) else {
            throw NetworkError.invalidRequest
        }
        
        print("-------------REQUEST-------------")
        print(urlRequest.cURL(pretty: true))
        print("-------------END REQUEST-------------")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        print("-------------RESPONSE-------------")
        print(String(decoding: data, as: UTF8.self))
        print("-------------END RESPONSE-------------")
        
        guard let pancakeResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if pancakeResponse.statusCode == 401 {
            //noti invalid token
        }
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(T.self, from: data)
    }
    
}

extension URLRequest {
    public func cURL(pretty: Bool = false) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
        
        var cURL = "curl "
        var header = ""
        var data: String = ""
        
        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key,value) in httpHeaders {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }
        
        if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8),  !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }
        
        cURL += method + url + header + data
        
        return cURL
    }
}
