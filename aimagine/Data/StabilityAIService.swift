//
//  StabilityAIService.swift
//  aimagine
//
//  Created by son on 27/09/2023.
//

import Foundation

protocol StabilityAIServiceProtocol {
    func getListEngines() async throws -> [Engine]
    func textToImage(request: TextToImageRequest) async throws -> [ImageResultDTO] 
}

class StabilityAIService: StabilityAIServiceProtocol {
     func getListEngines() async throws -> [Engine] {
        let request = NetworkRequestBuilder()
            .getRequest(endpoint: .engineList)
            .build()
        
        let engines: [Engine] = try await ApiManager.shared.request(with: request)
        
        return engines.filter { $0.type == "PICTURE" }
    }
    
    func textToImage(request: TextToImageRequest) async throws -> [ImageResultDTO] {
        let request = NetworkRequestBuilder()
            .path(Endpoint.textToImage.withArgument(request.engineId))
            .postJson(body: request)
            .build()
        
        let response: TextToImageResponse = try await ApiManager.shared.request(with: request)
        
        return response.artifacts ?? []
    }
}


