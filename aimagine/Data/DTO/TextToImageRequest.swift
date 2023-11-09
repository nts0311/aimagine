//
//  TextToImageRequest.swift
//  aimagine
//
//  Created by son on 04/10/2023.
//

import Foundation

struct TextToImageRequest: Encodable {
    var height: Double? = 512
    var width: Double? = 512
    var textPrompts: [TextPrompt]
    var cfgScale: Int? = 7
    var samples: Int? = 1
    var seed: Int? = nil
    var step: Int? = 50
    var stylePreset: String? = nil
    var engineId: String
    
    enum CodingKeys: String, CodingKey {
        case height
        case width
        case textPrompts = "text_prompts"
        case cfgScale = "cfg_scale"
        case samples
        case seed
        case step
        case stylePreset = "style_preset"
    }
    
    init(data: ImageGenerationData) {
        engineId = data.selectedEngine?.id ?? ""
        
        height = data.height
        width = data.width
        
        textPrompts = [
            TextPrompt(text: data.prompt, weight: 1)
        ]
        
        if let negativePrompt = data.negativePrompt,
           !negativePrompt.isEmpty {
            textPrompts.append(TextPrompt(text: negativePrompt, weight: -1))
        }
        
        cfgScale = Int(data.cfgScale)
        step = Int(data.steps)
        stylePreset = data.style?.code
    }
    
}


struct TextPrompt: Encodable {
    let text: String
    let weight: Double
}
