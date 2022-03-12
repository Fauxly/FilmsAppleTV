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
