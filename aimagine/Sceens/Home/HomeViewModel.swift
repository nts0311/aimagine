//
//  HomeViewModel.swift
//  aimagine
//
//  Created by son on 04/10/2023.
//

import Foundation

struct ImageGenerationData {
    var selectedEngine: Engine? = nil
    var style: StylePreset? = nil
    var prompt: String = ""
    var negativePrompt: String?
    var cfgScale: Double = 7
    var steps: Double = 50
    var width: Double = 512
    var height: Double = 512
}

@MainActor
class HomeViewModel: ObservableObject {
    @Published var data = ImageGenerationData()
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var isShowingResultScreen = false
    
    @Injected private var repo: StabilityAIRepositoryProtocol
    
    var engines: [Engine] {
        repo.engines
    }
    
    var disableGenerator: Bool {
        data.prompt.isEmpty
    }
    
    func loadEngine() {
        Task {
            await loadEngineAsync()
        }
    }
    
    func loadEngineAsync() async {
        guard engines.isEmpty else {
            return
        }
        
        isLoading = true
        do {
            try await repo.loadEngine()
            data.selectedEngine = repo.defaultEngine
        } catch {
            errorMessage = "Cannot load engines!"
        }
        
        isLoading = false
    }
    
    func beginGeneration() {
        Task {
            do {
                isLoading = true
                try await repo.generateImages(from: data)
                isLoading = false
                data = ImageGenerationData()
                isShowingResultScreen = true
            } catch {
                errorMessage = "An error occured. Please try again later."
            }
        }
    }
    
}
