//
//  PresetSizeGenerators.swift
//  aimagine
//
//  Created by son on 02/11/2023.
//

import Foundation

protocol EnginePresetSizeGeneratorProtocol {
    func generateSize() -> [EngineSize]
}

struct BoundedEnginePresetSizeGenerator: EnginePresetSizeGeneratorProtocol {
    let engine: Engine
    
    func generateSize() -> [EngineSize] {
        guard engine.is512Engine || engine.is768Engine else {
            return []
        }
        
        return [
            EngineSize(width: 1024, height: 1024, ratio: "1:1"),
            EngineSize(width: 1024, height: 768, ratio: "4:3"),
            EngineSize(width: 768, height: 1024, ratio: "3:4"),
            EngineSize(width: 1024, height: 576, ratio: "16:9"),
            EngineSize(width: 576, height: 1024, ratio: "9:16"),
        ]
    }
}

struct FixedEnginePresetSizeGenerator: EnginePresetSizeGeneratorProtocol {
    let engine: Engine
    
    func generateSize() -> [EngineSize] {
        guard engine.isFixedSizeEngine else {
            return []
        }
        
        return engine.supportSize ?? []
    }
}

struct EnginePresetSizeGeneratorProvider {
    let engine: Engine?
    
    func getGenerator() -> EnginePresetSizeGeneratorProtocol? {
        guard let engine else {
            return nil
        }
        
        if engine.is512Engine || engine.is768Engine {
            return BoundedEnginePresetSizeGenerator(engine: engine)
        } else if engine.isFixedSizeEngine {
            return FixedEnginePresetSizeGenerator(engine: engine)
        }
//        else if engine.engineType == .stableDiffusionXLBetav222 {
//            return SDXLBetaSizeValidator()
//        }
        
        return nil
    }
}
