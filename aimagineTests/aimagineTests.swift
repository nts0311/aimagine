//
//  aimagineTests.swift
//  aimagineTests
//
//  Created by son on 07/11/2023.
//

import XCTest

@testable import aimagine

final class BoundedSizeValidatorTests: XCTestCase {
    
    var sut: BoundedSizeValidator!
    var engine: Engine!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        engine = Engine(id: "stable-diffusion-512-v2-1", name: "Stable Diffusion v2.1", type: "PICTURE", description: "Stability-AI Stable Diffusion v2.1")
        
        sut = BoundedSizeValidator(engine: engine)
    }
    
    func testValidateCommonConditions() {
        let result1 = sut.metCommonConditions(width: 512, height: 512)
        XCTAssertEqual(result1, .metCommonConditions)
        
        let result2 = sut.metCommonConditions(width: -512, height: -512)
        XCTAssertEqual(result2, .notValid)
        
        let result3 = sut.metCommonConditions(width: -512, height: 512)
        XCTAssertEqual(result3, .notValid)
        
        let result4 = sut.metCommonConditions(width: 512, height: -512)
        XCTAssertEqual(result4, .notValid)
        
        let result5 = sut.metCommonConditions(width: 123, height: 512)
        XCTAssertEqual(result5, .notAMultipleOf64)
        
        let result6 = sut.metCommonConditions(width: 512, height: 123)
        XCTAssertEqual(result6, .notAMultipleOf64)
        
        let result7 = sut.metCommonConditions(width: 123, height: 123)
        XCTAssertEqual(result7, .notAMultipleOf64)
    }
    
    func testValidateSize() {
        let result1 = sut.validateSize(width: 512, height: 512)
        XCTAssertEqual(result1, .valid)
        
        let result2 = sut.validateSize(width: 2048, height: 2048)
        XCTAssertEqual(result2, .tooBig)
        
        let result3 = sut.validateSize(width: 128, height: 128)
        XCTAssertEqual(result3, .tooSmall)
        
        let result4 = sut.validateSize(width: 1024, height: 1024)
        XCTAssertEqual(result4, .valid)
        
        let result5 = sut.validateSize(width: 512, height: 512)
        XCTAssertEqual(result5, .valid)
    }
}
