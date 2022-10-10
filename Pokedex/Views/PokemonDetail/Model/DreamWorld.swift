//
//  DreamWorld.swift
//

import Foundation

struct DreamWorld: Codable, Hashable {
	let frontDefault: String?
	let frontFemale: String?

	enum CodingKeys: String, CodingKey {
		case frontDefault = "front_default"
		case frontFemale = "front_female"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		frontDefault = try values.decodeIfPresent(String.self, forKey: .frontDefault)
		frontFemale = try values.decodeIfPresent(String.self, forKey: .frontFemale)
	}
}
