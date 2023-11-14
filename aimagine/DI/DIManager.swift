//
//  DIManager.swift
//  aimagine
//
//  Created by son on 10/11/2023.
//

import Foundation

protocol DIManagerProtocol {
    var currentContainer: DIContainerProtocol { get }
}

class DIManager: DIManagerProtocol {
    static let shared = DIManager()
    
    var currentContainer: DIContainerProtocol = DIContainer()
    
    private init() { }

}
