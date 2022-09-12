//
//  PokemonDetailBase.swift
//

import Foundation

struct PokemonDetailBase: Codable, Hashable {
	let abilities: [Abilities]?
	let baseExperience : Int?
	let forms: [Forms]?
	let gameIndices: [GameIndices]?
	let height: Int?
	let heldItems: [Held]?
	let identifier: Int?
	let isDefault: Bool?
	let locationAreaEncounters: String?
	let moves: [Moves]?
	let name: String?
	let order: Int?
	let pastTypes: [PastType]?
	let species: Species?
	let sprites: Sprites?
	let stats: [Stats]?
    let types: [Types]?
	let weight: Int?

	enum CodingKeys: String, CodingKey {
		case abilities = "abilities"
		case baseExperience = "base_experience"
		case forms = "forms"
		case gameIndices = "game_indices"
		case height = "height"
		case heldItems = "held_items"
		case identifier = "id"
		case isDefault = "is_default"
		case locationAreaEncounters = "location_area_encounters"
		case moves = "moves"
		case name = "name"
		case order = "order"
		case pastTypes = "past_types"
		case species = "species"
		case sprites = "sprites"
		case stats = "stats"
        case types = "types"
		case weight = "weight"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		abilities = try values.decodeIfPresent([Abilities].self, forKey: .abilities)
		baseExperience = try values.decodeIfPresent(Int.self, forKey: .baseExperience)
		forms = try values.decodeIfPresent([Forms].self, forKey: .forms)
		gameIndices = try values.decodeIfPresent([GameIndices].self, forKey: .gameIndices)
		height = try values.decodeIfPresent(Int.self, forKey: .height)
		heldItems = try values.decodeIfPresent([Held].self, forKey: .heldItems)
        identifier = try values.decodeIfPresent(Int.self, forKey: .identifier)
		isDefault = try values.decodeIfPresent(Bool.self, forKey: .isDefault)
		locationAreaEncounters = try values.decodeIfPresent(String.self, forKey: .locationAreaEncounters)
		moves = try values.decodeIfPresent([Moves].self, forKey: .moves)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		order = try values.decodeIfPresent(Int.self, forKey: .order)
		pastTypes = try values.decodeIfPresent([PastType].self, forKey: .pastTypes)
		species = try values.decodeIfPresent(Species.self, forKey: .species)
		sprites = try values.decodeIfPresent(Sprites.self, forKey: .sprites)
		stats = try values.decodeIfPresent([Stats].self, forKey: .stats)
        types = try values.decodeIfPresent([Types].self, forKey: .types)
		weight = try values.decodeIfPresent(Int.self, forKey: .weight)
	}
}
