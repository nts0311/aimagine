//
//  DITests.swift
//  aimagineTests
//
//  Created by son on 11/11/2023.
//

import XCTest

@testable import aimagine

fileprivate protocol MockProtocol {
    
}

fileprivate class Mock: MockProtocol {
    
}

fileprivate class AltMock: MockProtocol {
    
}

final class DITests: XCTestCase {

    var sut: DIContainerProtocol!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DIContainer()
    }

    func test_RegistryTransientComponents() {
        sut.register(type: MockProtocol.self, Mock())
        
        let o1 = sut.resolve(MockProtocol.self) as? Mock
        let o2 = sut.resolve(MockProtocol.self) as? Mock
        
        XCTAssertNotNil(o1)
        XCTAssertNotNil(o2)
        XCTAssertNotIdentical(o1, o2, "Object should not be the same")
    }
    
    func test_RegistrySingletonComponents() {
        sut.register(type: MockProtocol.self, scope: .singleton, Mock())
        
        let o1 = sut.resolve(MockProtocol.self) as? Mock
        let o2 = sut.resolve(MockProtocol.self) as? Mock
        
        XCTAssertNotNil(o1)
        XCTAssertNotNil(o2)
        XCTAssertIdentical(o1, o2, "Object should be the same")
    }
    
    func test_RegistryWithNames() {
        let name1 = "mock"
        let name2 = "altmock"
        
        sut.register(type: MockProtocol.self, name: name1, Mock())
        sut.register(type: MockProtocol.self, name: name2, AltMock())
        
        let o1 = sut.resolve(MockProtocol.self, name1)
        let o2 = sut.resolve(MockProtocol.self, name2)
        
        XCTAssertNotNil(o1)
        XCTAssertNotNil(o2)
        XCTAssertNotNil(o1 as? Mock)
        XCTAssertNotNil(o2 as? AltMock)
    }
}
