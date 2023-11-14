//
//  ImageRepository.swift
//  aimagine
//
//  Created by son on 10/11/2023.
//

import Combine

//protocol StabilityAIRepositoryProtocol2 {
//    var value: Bool { get set }
//    var valuePublisher: Published<Bool>.Publisher { get }
//}
//
//class test: StabilityAIRepositoryProtocol2 {
//    @Published var value: Bool
//
//    var valuePublisher: Published<Bool>.Publisher {
//        $value
//    }
//
//    init(value: Bool) {
//        self.value = value
//    }
//}

protocol StabilityAIRepositoryProtocol {
    var engines: [Engine] { get }
    var generatedHistory: [GeneratedImageResult] { get }
    var defaultEngine: Engine? { get }
    var latestResult: GeneratedImageResult? { get }
    
    var historyPublisher: Published<[GeneratedImageResult]>.Publisher { get }
    
    func loadEngine() async throws
    func generateImages(from data: ImageGenerationData) async throws -> GeneratedImageResult
    func generateImages(from request: TextToImageRequest) async throws -> GeneratedImageResult
}

class StabilityAIRepository: StabilityAIRepositoryProtocol {

    @Published var generatedHistory: [GeneratedImageResult] = []
    var engines: [Engine] = []
    
    @Injected private var stabilityAIService: StabilityAIServiceProtocol
    
    var latestResult: GeneratedImageResult? {
        generatedHistory.last
    }
    
    var defaultEngine: Engine? {
        engines.first(where: {
            $0.id == "stable-diffusion-512-v2-0"
        })
    }
    
    var historyPublisher: Published<[GeneratedImageResult]>.Publisher {
        $generatedHistory
    }
}

extension StabilityAIRepository {
    
    @MainActor
    func loadEngine() async throws {
        guard engines.isEmpty else {
            return
        }
        
        engines = try await stabilityAIService.getListEngines()
    }
    
    func generateImages(from data: ImageGenerationData) async throws -> GeneratedImageResult {
        let request = TextToImageRequest(data: data)
        return try await generateImages(from: request)
    }
    
    @MainActor
    func generateImages(from request: TextToImageRequest) async throws -> GeneratedImageResult {
        let images = try await stabilityAIService.textToImage(request: request)
        
        let generatedResult = GeneratedImageResult(request: request, images: images)
        
        if !images.isEmpty {
            generatedHistory.append(generatedResult)
        }
        
        return generatedResult
    }
    
}
