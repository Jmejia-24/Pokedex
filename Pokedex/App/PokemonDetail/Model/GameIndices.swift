//
//  GameIndices.swift
//

import Foundation

struct GameIndices: Codable, Hashable {
	let gameIndex: Int?
	let version: Species?

	enum CodingKeys: String, CodingKey {
		case gameIndex = "game_index"
		case version = "version"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		gameIndex = try values.decodeIfPresent(Int.self, forKey: .gameIndex)
		version = try values.decodeIfPresent(Species.self, forKey: .version)
	}
}
