//
//  SizeValidators.swift
//  aimagine
//
//  Created by son on 02/11/2023.
//

import Foundation

protocol ImageSizeValidatorProtocol {
    func validateSize(width: Double, height: Double) -> SizeValidity
}

extension ImageSizeValidatorProtocol {
    func metCommonConditions(width: Double, height: Double) -> SizeValidity {
        guard width > 0, height > 0 else {
            return .notValid
        }
        
        guard width.isMultipleOf64, height.isMultipleOf64 else {
            return .notAMultipleOf64
        }
        
        return .metCommonConditions
    }
}

struct BoundedSizeValidator: ImageSizeValidatorProtocol {
    let engine: Engine
    
    func validateSize(width: Double, height: Double) -> SizeValidity {
        let isCommonConditionMet = metCommonConditions(width: width, height: height)
        guard isCommonConditionMet == .metCommonConditions else {
            return isCommonConditionMet
        }
        
        guard let minSizeProduct = self.engine.minSizeProduct,
              let maxSizeProduct = self.engine.maxSizeProduct else {
            return .notSupport
        }
        
        let sizeProduct = width * height
        
        guard sizeProduct >= minSizeProduct else {
            return .tooSmall
        }
        
        guard sizeProduct <= maxSizeProduct else {
            return .tooBig
        }
        
        return .valid
    }
}

struct SDXLBetaSizeValidator: ImageSizeValidatorProtocol {
    func validateSize(width: Double, height: Double) -> SizeValidity {
        let isCommonConditionMet = metCommonConditions(width: width, height: height)
        guard isCommonConditionMet == .metCommonConditions else {
            return isCommonConditionMet
        }
        
        if isFirstDimensionInValidRange(d: width) && isSecondaryDimensionInValidRange(d: height) ||
            isFirstDimensionInValidRange(d: height) && isSecondaryDimensionInValidRange(d: width) {
            return .valid
        } else {
            return .notSupport
        }
        
    }
    
    private func isFirstDimensionInValidRange(d: Double) -> Bool {
        d >= 128 && d <= 896
    }
    
    private func isSecondaryDimensionInValidRange(d: Double) -> Bool {
        d >= 128 && d <= 512
    }
}

struct FixedSizeValidator: ImageSizeValidatorProtocol {
    let engine: Engine
    
    func validateSize(width: Double, height: Double) -> SizeValidity {
        let isCommonConditionMet = metCommonConditions(width: width, height: height)
        guard isCommonConditionMet == .metCommonConditions else {
            return isCommonConditionMet
        }
        
        guard engine.isFixedSizeEngine,
              let supportSizes = engine.supportSize else {
            return .notSupport
        }
        
        return supportSizes.contains { preset in
            preset.width == width && preset.height == height
        } ? .valid : .notValid
    }
}

fileprivate extension Double {
    var isMultipleOf64: Bool {
        self.truncatingRemainder(dividingBy: 64.0) == 0
    }
}

struct SizeValidatorProvider {
    let engine: Engine?
    func getSizeValidator() -> ImageSizeValidatorProtocol? {
        guard let engine else {
            return nil
        }
        
        if engine.is512Engine || engine.is768Engine {
            return BoundedSizeValidator(engine: engine)
        } else if engine.isFixedSizeEngine {
            return FixedSizeValidator(engine: engine)
        }
        else if engine.engineType == .stableDiffusionXLBetav222 {
            return SDXLBetaSizeValidator()
        }
        
        return nil
    }
}

