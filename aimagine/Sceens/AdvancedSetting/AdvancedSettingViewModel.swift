//
//  AdvancedSettingViewModel.swift
//  aimagine
//
//  Created by son on 23/10/2023.
//

import Foundation

class AdvancedSettingViewModel: ObservableObject {
    @Published var data = ImageGenerationData()
    
    @Published var selectedPresetIndex: Int? = nil {
        didSet {
            onSelectPreset()
        }
    }
    
    var engine: Engine {
        data.selectedEngine!
    }
    
    private let sizeValidator: ImageSizeValidatorProtocol?
    private let sizePresetGenerator: EnginePresetSizeGeneratorProtocol?
    
    var supportSize: [EngineSize]? {
        engine.supportSize
    }
    
    var sizeValidity: SizeValidity {
        guard let sizeValidator else {
            return .valid
        }
        
        return sizeValidator.validateSize(width: data.width, height: data.height)
    }
    
    var errorMessage: String? {
        !sizeValidity.isValid ? sizeValidity.errorMessage : nil
    }
    
    var hasError: Bool{
        !sizeValidity.isValid
    }
    
    var presetSizes: [EngineSize] {
        sizePresetGenerator?.generateSize() ?? []
    }
    
    var selectedPreset: EngineSize? {
        guard let selectedPresetIndex else {
            return nil
        }
        
        return presetSizes[selectedPresetIndex]
    }
    
    init(data: ImageGenerationData) {
        self.data = data
        let engine = data.selectedEngine
        self.sizeValidator = SizeValidatorProvider(engine: engine).getSizeValidator()
        self.sizePresetGenerator = EnginePresetSizeGeneratorProvider(engine: engine).getGenerator()
    }
    
    func resetSize() {
        data.width = 512
        data.height = 512
    }
    
    func onSelectPreset() {
        guard let selectedPreset else {
            return
        }
        
        data.width = selectedPreset.width
        data.height = selectedPreset.height
    }
}

extension EngineSize: ChipItemData {
    var iconName: String? {
        nil
    }
    
    var text: String {
        ratio
    }
}
