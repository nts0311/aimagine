//
//  aimagineApp.swift
//  aimagine
//
//  Created by son on 04/09/2023.
//

import SwiftUI
import Combine

class StabilityAIServiceMock: StabilityAIServiceProtocol {
    func getListEngines() async throws -> [Engine] {
        return [
            Engine(id: "stable-diffusion-512-v2-0", name: "SD 512 v2", type: "stable-diffusion-512-v2-0", description: "stable-diffusion-512-v2-0")
        ]
    }
    
    func textToImage(request: TextToImageRequest) async throws -> [ImageResultDTO] {
        try await Task.sleep(nanoseconds: 3_000_000_000)
        return ResultDTOProvider.getResult()
    }
}

@main
struct aimagineApp: App {
    
    init() {
        initComponents()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                //.onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
}

extension aimagineApp {
    func initComponents() {
        let diContainer = DIManager.shared.currentContainer
        
        diContainer.register(type: StabilityAIServiceProtocol.self, StabilityAIServiceMock())
        diContainer.register(type: StabilityAIRepositoryProtocol.self, scope: .singleton, StabilityAIRepository())
    }
}


extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}
