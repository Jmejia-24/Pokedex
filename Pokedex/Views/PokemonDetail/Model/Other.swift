//
//  Other.swift
//

import Foundation
struct Other: Codable, Hashable {
	let dreamWorld: DreamWorld?
	let home: Home?
	let officialArtwork: OfficialArtwork?

	enum CodingKeys: String, CodingKey {
		case dreamWorld = "dream_world"
		case home = "home"
        // NOTE: SOME FUNNY NAMES NEED TO BE MANUAL
		case officialArtwork = "official-artwork"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dreamWorld = try values.decodeIfPresent(DreamWorld.self, forKey: .dreamWorld)
		home = try values.decodeIfPresent(Home.self, forKey: .home)
        officialArtwork = try values.decodeIfPresent(OfficialArtwork.self, forKey: .officialArtwork)
	}
}
