//
//  GetEngineList.swift
//  aimagine
//
//  Created by son on 27/09/2023.
//

import Foundation

enum EngineType {
    case stableDiffusionXLv09
    case stableDiffusionXLv10
    case stableDiffusionv14
    case stableDiffusionv15
    case stableDiffusionv2
    case stableDiffusionv2_768
    case stableDiffusionv2Depth
    case stableDiffusionv21
    case stableDiffusionv21_768
    case stableDiffusionXLBetav222
    case unknown
    
    init(engineId: String) {
        switch engineId {
        case "stable-diffusion-xl-1024-v0-9":
            self = .stableDiffusionXLv09
            
        case "stable-diffusion-xl-1024-v1-0":
            self = .stableDiffusionXLv10
            
        case "stable-diffusion-v1":
            self = .stableDiffusionv14
            
        case "stable-diffusion-v1-5":
            self = .stableDiffusionv15
            
        case "stable-diffusion-512-v2-0":
            self = .stableDiffusionv2
            
        case "stable-diffusion-768-v2-0":
            self = .stableDiffusionv2_768
            
        case "stable-diffusion-depth-v2-0":
            self = .stableDiffusionv2Depth
            
        case "stable-diffusion-512-v2-1":
            self = .stableDiffusionv21
            
        case "stable-diffusion-768-v2-1":
            self = .stableDiffusionv21_768
            
        case "stable-diffusion-xl-beta-v2-2-2":
            self = .stableDiffusionXLBetav222
            
        default:
            self = .unknown
        }
    }
    
}

struct Engine: Decodable, Identifiable {
    let id: String?
    let name: String?
    let type: String?
    let description: String?
    
    var engineType: EngineType {
        EngineType(engineId: id ?? "")
    }
    
    var is512Engine: Bool {
        switch engineType {
        case .stableDiffusionv2, .stableDiffusionv21:
            return true
            
        default:
            return false
        }
    }
    
    var is768Engine: Bool {
        switch engineType {
        case .stableDiffusionv2_768, .stableDiffusionv21_768:
            return true
            
        default:
            return false
        }
    }
    
    var isFixedSizeEngine: Bool {
        engineType == .stableDiffusionXLv09 || engineType == .stableDiffusionXLv10
    }
    
    var minSizeProduct: Double? {
        if is512Engine {
            return 262144
        }
        
        if is768Engine {
            return 589824
        }
        
        return nil
    }
    
    var maxSizeProduct: Double? {
        if is512Engine || is768Engine {
            return 1048576
        }
        
        return nil
    }
   
    
    var supportSize: [EngineSize]? {
        switch engineType {
        case .stableDiffusionXLv09, .stableDiffusionXLv10:
            return [
                EngineSize(width: 1024, height: 1024, ratio: "1:1"),
                EngineSize(width: 1152, height: 896, ratio: "9:7"),
                EngineSize(width: 1216, height: 832, ratio: "19:13"),
                EngineSize(width: 1344, height: 768, ratio: "7:4"),
                EngineSize(width: 1536, height: 640, ratio: "12:5"),
                EngineSize(width: 640, height: 1536, ratio: "5:12"),
                EngineSize(width: 768, height: 1344, ratio: "4:7"),
                EngineSize(width: 832, height: 1216, ratio: "13:19"),
                EngineSize(width: 896, height: 1152, ratio: "7:9"),
            ]
            
        default:
            return nil
        }
    }
    
    var shortName: String {
        (name ?? "").replacingOccurrences(of: "Stable Diffusion", with: "SD")
    }
    
}

struct EngineSize {
    let width: CGFloat
    let height: CGFloat
    let ratio: String
    var isHighQuality: Bool = false
    
    var description: String {
        return "\(width)x\(height)"
    }
}

struct GetEngineListResponse {
    
}
