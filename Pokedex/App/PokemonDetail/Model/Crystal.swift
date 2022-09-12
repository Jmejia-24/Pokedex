//
//  Crystal.swift
//

import Foundation

struct Crystal: Codable {
	let backDefault: String?
	let backShiny: String?
	let backShinyTransparent: String?
	let backTransparent: String?
	let frontDefault: String?
	let frontShiny: String?
	let frontShinyTransparent: String?
	let frontTransparent: String?

	enum CodingKeys: String, CodingKey {
		case backDefault = "back_default"
		case backShiny = "back_shiny"
		case backShinyTransparent = "back_shiny_transparent"
		case backTransparent = "back_transparent"
		case frontDefault = "front_default"
		case frontShiny = "front_shiny"
		case frontShinyTransparent = "front_shiny_transparent"
		case frontTransparent = "front_transparent"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		backDefault = try values.decodeIfPresent(String.self, forKey: .backDefault)
		backShiny = try values.decodeIfPresent(String.self, forKey: .backShiny)
		backShinyTransparent = try values.decodeIfPresent(String.self, forKey: .backShinyTransparent)
		backTransparent = try values.decodeIfPresent(String.self, forKey: .backTransparent)
		frontDefault = try values.decodeIfPresent(String.self, forKey: .frontDefault)
		frontShiny = try values.decodeIfPresent(String.self, forKey: .frontShiny)
		frontShinyTransparent = try values.decodeIfPresent(String.self, forKey: .frontShinyTransparent)
		frontTransparent = try values.decodeIfPresent(String.self, forKey: .frontTransparent)
	}
}
