//
//  NetworkRequest.swift
//  AutoPancake
//
//  Created by son on 01/07/2023.
//

import Foundation

enum RequestType {
    case get
    case postFromData([MultipartFormField])
    case postJson(Encodable)
    
    var strValue: String {
        switch self {
        case .get:
            return "GET"
        case .postFromData, .postJson:
            return "POST"
        }
    }
    
}

struct NetworkRequest {
    var path: String
    var type: RequestType
    var header: [String: Any] = defaultHeaders
    var queryParams: [String: Any] = defaultQueryParams
    var jsonBody: Encodable?
    
    var multipartForm: [MultipartFormField]? {
        if case let .postFromData(form) = self.type {
            return form
        } else {
            return nil
        }
    }
    
    func getUrlRequest(baseURL: String) -> URLRequest? {
        switch type {
        case .get: return createGetURLRequest(with: baseURL)
        case .postFromData: return createPostFormURLRequest(with: baseURL)
        case .postJson: return createPostJson(with: baseURL)
        }
    }
}

class NetworkRequestBuilder {
    private var request = NetworkRequest(path: "", type: .get, header: NetworkRequest.defaultHeaders)
    
    func getRequest(endpoint: Endpoint) -> NetworkRequestBuilder {
        request.type = .get
        request.path = endpoint.rawValue
        return self
    }
    
    func getRequest(path: String) -> NetworkRequestBuilder {
        request.type = .get
        request.path = path
        return self
    }
    
    func path(_ path: String) -> NetworkRequestBuilder {
        request.path = path
        return self
    }
    
    func path(_ endpoint: Endpoint) -> NetworkRequestBuilder {
        request.path = endpoint.rawValue
        return self
    }
    
    func postFormData(formData: [MultipartFormField]) -> NetworkRequestBuilder {
        request.type = .postFromData(formData)
        return self
    }
    
    func setHeader(_ header: [String: Any]) -> NetworkRequestBuilder {
        request.header = header
        return self
    }
    
    func setQueryParams(_ params: [String: Any]) -> NetworkRequestBuilder {
        request.queryParams = params
        return self
    }
    
    func build() -> NetworkRequest {
        request
    }
    
    func addQueryParam(name: String, value: String) -> NetworkRequestBuilder {
        request.queryParams[name] = value
        return self
    }
    
    func postJson(endpoint: Endpoint, body: Encodable) -> NetworkRequestBuilder {
        request.type = .postJson(body)
        request.path = endpoint.rawValue
        request.jsonBody = body
        return self
    }
    
    func postJson(body: Encodable) -> NetworkRequestBuilder {
        request.type = .postJson(body)
        request.jsonBody = body
        return self
    }
}

