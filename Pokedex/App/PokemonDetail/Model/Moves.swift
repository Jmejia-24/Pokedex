//
//  Moves.swift
//

import Foundation
struct Moves: Codable, Hashable {
	let move: Move?
	let versionGroupDetails: [VersionGroupDetails]?

	enum CodingKeys: String, CodingKey {
		case move = "move"
		case versionGroupDetails = "version_group_details"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		move = try values.decodeIfPresent(Move.self, forKey: .move)
		versionGroupDetails = try values.decodeIfPresent([VersionGroupDetails].self, forKey: .versionGroupDetails)
	}
}
