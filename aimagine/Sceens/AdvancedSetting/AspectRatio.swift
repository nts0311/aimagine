//
//  AspectRatio.swift
//  aimagine
//
//  Created by son on 13/10/2023.
//

import Foundation

enum AspectRatio: CaseIterable {
    case ar11
    case ar43
    case ar34
    case ar32
    case ar23
    case ar169
    case ar916
    case ar54
    case ar45
    
    var displayTitle: String {
        switch self {
        case .ar11:
            return "1:1"
        case .ar43:
            return "4:3"
        case .ar34:
            return "3:4"
        case .ar32:
            return "3:2"
        case .ar23:
            return "2:3"
        case .ar169:
            return "16:9"
        case .ar916:
            return "9:16"
        case .ar54:
            return "5:4"
        case .ar45:
            return "4:5"
        }
    }
}

extension AspectRatio: ChipItemData {
    var iconName: String? {
        nil
    }
    
    var text: String {
        displayTitle
    }
}
