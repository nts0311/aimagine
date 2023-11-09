//
//  ImageGenerationStore.swift
//  aimagine
//
//  Created by son on 12/10/2023.
//

import Foundation

struct GeneratedImageResult {
    let request: TextToImageRequest
    let images: [ImageResultDTO]
}

extension GeneratedImageResult: ResultScreenData {
    var resultImages: [ImageResultDTO] {
        images
    }
}

@MainActor
class ImageGenerationStore: ObservableObject {
    @Published var generatedHistory: [GeneratedImageResult] = []
    @Published var engines: [Engine] = []
    
    var defaultEngine: Engine? {
        engines.first(where: {
            $0.id == "stable-diffusion-512-v2-0"
        })
    }
    
    var latestResult: GeneratedImageResult? {
        generatedHistory.last
    }
    
    func loadEngine() async throws {
        guard engines.isEmpty else {
            return
        }
        
        engines = try await StabilityAIService.getListEngines()
    }
    
    func generateImages(from data: ImageGenerationData) async throws -> GeneratedImageResult {
        let request = TextToImageRequest(data: data)
        return try await generateImages(from: request)
    }
    
    func generateImages(from request: TextToImageRequest) async throws -> GeneratedImageResult {
        let images = try await StabilityAIService.textToImage(request: request)
        
        let generatedResult = GeneratedImageResult(request: request, images: images)
        
        if !images.isEmpty {
            generatedHistory.append(generatedResult)
        }
        
        return generatedResult
    }
    
}
