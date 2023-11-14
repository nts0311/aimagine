//
//  StabilityAIServiceMock.swift
//  aimagineTests
//
//  Created by son on 11/11/2023.
//

import Foundation

@testable import aimagine

class StabilityAIServiceMock: StabilityAIServiceProtocol {
    func getListEngines() async throws -> [Engine] {
        return [
            Engine(id: "stable-diffusion-512-v2-0", name: "SD 512 v2", type: "stable-diffusion-512-v2-0", description: "stable-diffusion-512-v2-0")
        ]
    }
    
    func textToImage(request: TextToImageRequest) async throws -> [ImageResultDTO] {
        return ResultDTOProvider.getResult()
    }
}

