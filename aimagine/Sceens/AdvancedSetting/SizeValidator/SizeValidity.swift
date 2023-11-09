//
//  SizeValidity.swift
//  aimagine
//
//  Created by son on 02/11/2023.
//

import Foundation

enum SizeValidity {
    case valid
    case notValid
    case tooSmall
    case tooBig
    case notSupport
    case notAMultipleOf64
    case metCommonConditions
    
    var errorMessage: String {
        switch self {
        case .valid:
            return "Size is valid"
        case .notValid:
            return "Size is not valid"
        case .tooSmall:
            return "Image size is too small"
        case .tooBig:
            return "Image size is too big"
        case .notSupport:
            return "Size not support by Engine"
            
        case .metCommonConditions:
            return ""
            
        case .notAMultipleOf64:
            return "Width or Height is not a multiple of 64"
        }
    }
    
    var isValid: Bool {
        self == .valid
    }
}
