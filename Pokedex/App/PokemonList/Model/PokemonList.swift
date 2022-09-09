//
//  PokemonList.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/8/22.
//

import Foundation

struct AllPokemonBase: Codable {
    let count : Int
    let next : String?
    let previous : String?
    let results : [Pokemon]
}
