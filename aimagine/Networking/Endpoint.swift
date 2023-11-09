//
//  Endpoint.swift
//  AutoPancake
//
//  Created by son on 01/07/2023.
//

import Foundation

enum Endpoint: String {
    case engineList = "/v1/engines/list"
    
    case textToImage = "/v1/generation/%@/text-to-image"
    
    func withArgument(_ arguments: CVarArg...) -> String {
        String(format: self.rawValue, arguments)
    }
}
