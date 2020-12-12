//
//  Films.swift
//  COSMOTV
//
//  Created by Maxim Pyatovky on 11.12.2020.
//

import Foundation

// MARK: - Films
struct Films: Codable {
    let result: Bool
    let data: [Datum]
    let current_page: Int
    let first_page_url: String
    let from, last_page: Int
    let last_page_url, next_page_url, path: String
    let per_page: Int
    let prev_page_url: JSONNull?
    let to, total: Int

    enum CodingKeys: String, CodingKey {
        case result, data
        case current_page
        case first_page_url
        case from
        case last_page
        case last_page_url
        case next_page_url
        case path
        case per_page
        case prev_page_url
        case to, total
    }
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let title: String
    let kp_id, imdb_id, worldArt_id: String?
    let type: TypeEnum
    let add, orig_title, year: String
    let translations: [String]
    let quality, translation: String?
    let update, iframe_src: String
    let seasonsCount, episodesCount, episodes: Int?

    enum CodingKeys: String, CodingKey {
        case id, title
        case kp_id
        case imdb_id
        case worldArt_id
        case type, add
        case orig_title
        case year, translations, quality, translation, update
        case iframe_src
        case seasonsCount
        case episodesCount
        case episodes
    }
}

enum TypeEnum: String, Codable {
    case movie = "movie"
    case serial = "serial"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
