//
//  DIContainer.swift
//  aimagine
//
//  Created by son on 10/11/2023.
//

import Foundation


protocol DIContainerProtocol {
    var factories: [String: () -> Any] { get }
    var cache: [String: Any] { get }
    
    func register<Component>(
        type: Component.Type,
        scope: ComponentScope,
        name: String?,
        _ factory: @autoclosure @escaping () -> Component
    )
    
    func resolve<Component>(_ type: Component.Type, _ name: String?) -> Component?
}

extension DIContainerProtocol {
    func register<Component>(
        type: Component.Type,
        _ factory: @autoclosure @escaping () -> Component
    ) {
        register(type: type, scope: .transient, name: nil, factory())
    }
    
    func register<Component>(
        type: Component.Type,
        scope: ComponentScope,
        _ factory: @autoclosure @escaping () -> Component
    ) {
        register(type: type, scope: scope, name: nil, factory())
    }
    
    func register<Component>(
        type: Component.Type,
        name: String?,
        _ factory: @autoclosure @escaping () -> Component
    ){
        register(type: type, scope: .transient, name: name, factory())
    }
    
    func resolve<Component>(_ type: Component.Type) -> Component? {
        resolve(type, nil)
    }
}

class DIContainer: DIContainerProtocol {
    private(set) var factories: [String : () -> Any] = [:]
    private(set) var cache: [String : Any] = [:]
    private(set) var scopes: [String : ComponentScope] = [:]
    
    func register<Component>(
        type: Component.Type,
        scope: ComponentScope,
        name: String?,
        _ factory: @autoclosure @escaping () -> Component
    ) {
        let componentId = getComponentId(type: type, name: name)
        factories[componentId] = factory
        scopes[componentId] = scope
    }
    
    func resolve<Component>(_ type: Component.Type, _ name: String?) -> Component?  {
        let componentId = getComponentId(type: type, name: name)
        let scope = scopes[componentId]
        
        switch scope {
        case .transient:
            return createComponent(type, name: name)
            
        case .singleton:
            if let component = cache[componentId] as? Component {
                return component
            } else {
                let component = createComponent(type, name: name)
                
                if let component {
                    cache[componentId] = component
                }
                
                return component
            }
            
        default:
            return nil
        }
        
    }
    
    private func getComponentId<Component>(type: Component.Type, name: String?) -> String {
        let typeName = String(describing: type)
        
        if let name {
            return "\(typeName)_\(name)"
        } else {
            return typeName
        }
    }
    
    private func createComponent<Component>(_ type: Component.Type, name: String?) -> Component? {
        let typeName = getComponentId(type: type, name: name)
        let componentFactory = factories[typeName]
        let component = componentFactory?()
        return component as? Component
    }
    
}
