//
//  FramesFilms.swift
//  COSMOTV
//
//  Created by Maxim Pyatovky on 13.12.2020.
//

import Foundation

// MARK: - FramesFilms
struct FramesFilms: Codable {
    let frames: [Frame]?
}

// MARK: - Frame
struct Frame: Codable {
    let image, preview: String?
    enum CodingKeys: String, CodingKey {
        case image, preview
    }
}
