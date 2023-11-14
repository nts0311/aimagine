//
//  RepoTests.swift
//  aimagineTests
//
//  Created by son on 11/11/2023.
//

import XCTest
import Combine

@testable import aimagine

@MainActor final class RepoTests: XCTestCase {

    var sut: StabilityAIRepositoryProtocol!
    private var cancellables: Set<AnyCancellable>!
    
    @MainActor override func setUpWithError() throws {
        //let container = DIContainer()
        
        //container.register(type: StabilityAIServiceProtocol.self, StabilityAIServiceMock())
        
        DIManager.shared.currentContainer.register(type: StabilityAIServiceProtocol.self, StabilityAIServiceMock())
        
        sut = StabilityAIRepository()
        cancellables = []
    }

    func test_CacheEnginesAfterLoad() async {
        try! await sut.loadEngine()
        XCTAssertTrue(!sut.engines.isEmpty)
        XCTAssertNotNil(sut.defaultEngine)
    }

    func test_GenImage() async {
        let latestResult = try! await sut.generateImages(from: ImageGenerationData())
        //try! awaitPublisher(sut.historyPublisher.eraseToAnyPublisher())
        let history = try! awaitPublisher(sut.historyPublisher.eraseToAnyPublisher())
       
        
        XCTAssertTrue(!history.isEmpty)
        XCTAssertTrue(history.last == latestResult)
        XCTAssertNotNil(sut.latestResult)
    }
}

extension XCTestCase {
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 3,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")
        
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }
                
                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
                //expectation.fulfill()
            }
        )
        
        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout, handler: nil)
        //wait(for: [expectation], timeout: timeout)
        cancellable.cancel()
        
        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )
        
        return try unwrappedResult.get()
    }
}
