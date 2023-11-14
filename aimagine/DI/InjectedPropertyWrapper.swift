//
//  InjectedPropertyWrapper.swift
//  aimagine
//
//  Created by son on 10/11/2023.
//

import Foundation

@propertyWrapper
struct Injected<Component> {
    
    var component: Component
    
    var wrappedValue: Component {
        get { component }
        set { component = newValue }
    }
    
    init(_ name: String? = nil) {
        guard let component = DIManager.shared.currentContainer.resolve(Component.self, name) else {
            let type = String(describing: Component.self)
            fatalError("No coponent of type \(type) registed!")
        }
        
        self.component = component
    }
    
}
