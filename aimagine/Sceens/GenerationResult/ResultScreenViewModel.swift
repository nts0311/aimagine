//
//  ResultScreenViewModel.swift
//  aimagine
//
//  Created by son on 12/11/2023.
//

import Foundation

@MainActor
class ResultScreenViewModel: ObservableObject {
    @Published var currentResult: GeneratedImageResult?
    @Published var historyImages: [ImageResultDTO] = []
    @Published var currentPrompt: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var currentImageIndex = 0
    
    @Injected var repo: StabilityAIRepositoryProtocol
    
    var currentItems: [ImageResultDTO] {
        currentResult?.images ?? []
    }
    
    init() {
        repo.historyPublisher
            .map { resultItem in
                resultItem.map(\.images).compactMap(\.first)
            }
            .assign(to: &$historyImages)
        
        $currentResult
            .compactMap(\.?.request)
            .map(\.textPrompts)
            .map { prompts in
                prompts.first(where: {$0.isMainPrompt})?.text ?? ""
            }
            .assign(to: &$currentPrompt)
        
//        $currentResult
//            .compactMap(\.?.images)
//            .assign(to: &$currentItems)
        
        currentResult = repo.latestResult
    }
    
    func setCurrentResultItem(_ index: Int) {
        currentResult = repo.generatedHistory[index]
        currentImageIndex = 0
    }
    
    func generateMore() {
        Task {
            do {
                isLoading = true
                var request = currentResult!.request
                request.replaceMainPrompt(currentPrompt)
                try await repo.generateImages(from: request)
                isLoading = false
            } catch {
                errorMessage = "An error occured. Please try again later."
            }
        }
    }
    
}
