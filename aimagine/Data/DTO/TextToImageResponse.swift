//
//  TextToImageResponse.swift
//  aimagine
//
//  Created by son on 05/10/2023.
//

import UIKit

struct TextToImageResponse: Decodable {
    let artifacts: [ImageResultDTO]?
}

protocol UIImageConvertible {
    var uiImage: UIImage { get }
}

struct ImageResultDTO: Decodable {
    let base64: String?
    let finishReason: String?
    let id: UUID = UUID()
}

extension ImageResultDTO: Identifiable { }

extension ImageResultDTO: UIImageConvertible {
    var uiImage: UIImage {
        guard let base64,
              let data = Data(base64Encoded: base64)
        else {
            return UIImage()
        }

        return UIImage(data: data) ?? UIImage()
    }
}
