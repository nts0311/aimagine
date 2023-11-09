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
