//
//  NetworkRequest+Params.swift
//  AutoPancake
//
//  Created by son on 01/07/2023.
//

import Foundation

//fileprivate let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJhYWZhNzM4NS1jZmI1LTQyMGEtYTJjZi0xYjVmOTRkYWUwNTciLCJpYXQiOjE2ODgwMjA0OTMsImZiX25hbWUiOiJEdXkgxJDhuqF0IiwiZmJfaWQiOiIxMDI2ODI3NTk0MTk2NzEiLCJleHAiOjE2OTU3OTY0OTN9._gUl39gg_aWxDAsRXYzfuIRH4Orw5z3GrCyQ_yfC0ao"

extension NetworkRequest {
    static var defaultQueryParams: [String: String] {
        [:]
    }
    
    static var defaultHeaders: [String: String] {
        [
            "Authorization": stabilityAIKey
        ]
    }
}
