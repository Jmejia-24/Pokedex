//
//  OfficialArtwork.swift
//

import Foundation

struct OfficialArtwork: Codable, Hashable {
	let frontDefault: String?

	enum CodingKeys: String, CodingKey {
		case frontDefault = "front_default"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		frontDefault = try values.decodeIfPresent(String.self, forKey: .frontDefault)
	}
}
