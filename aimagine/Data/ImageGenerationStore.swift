//
//  ImageGenerationStore.swift
//  aimagine
//
//  Created by son on 12/10/2023.
//

import Foundation

struct GeneratedImageResult: Equatable {
    let request: TextToImageRequest
    let images: [ImageResultDTO]
}

extension GeneratedImageResult: ResultScreenData {
    var resultImages: [ImageResultDTO] {
        images
    }
}

//@MainActor
//class ImageGenerationStore: ObservableObject {
//    @Published var generatedHistory: [GeneratedImageResult] = []
//    @Published var engines: [Engine] = []
//    
//    
//    
//    func loadEngine() async throws {
//        guard engines.isEmpty else {
//            return
//        }
//        
//        engines = try await StabilityAIService.getListEngines()
//    }
//    
//    func generateImages(from data: ImageGenerationData) async throws -> GeneratedImageResult {
//        let request = TextToImageRequest(data: data)
//        return try await generateImages(from: request)
//    }
//    
//    func generateImages(from request: TextToImageRequest) async throws -> GeneratedImageResult {
//        let images = try await StabilityAIService.textToImage(request: request)
//        
//        let generatedResult = GeneratedImageResult(request: request, images: images)
//        
//        if !images.isEmpty {
//            generatedHistory.append(generatedResult)
//        }
//        
//        return generatedResult
//    }
//    
//}
