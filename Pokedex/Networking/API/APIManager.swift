//
//  APIManager.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/8/22.
//

import Foundation
import Combine

protocol PokemonListStore {
    func readPokemonList(offset: Int) -> Future<AllPokemonBase, Failure>
}

final class APIManager {
    static let serviceURL = "https://pokeapi.co/api/v2/"
}

extension APIManager: PokemonListStore {
    func readPokemonList(offset: Int) -> Future<AllPokemonBase, Failure> {
        let path = "pokemon?limit=50&offset=\(offset)"
        return Future { promise in
            guard let url = URL(string: APIManager.serviceURL + path) else {
                promise(.failure(.urlConstructError))
                return
            }
            
            // TODO: Add invalidate and Cancel functionality when a subscription to this future is completed or errored
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, case .none = error else { promise(.failure(.urlConstructError)); return }
                do {
                    let decoder = JSONDecoder()
                    let allPokemonBase = try decoder.decode(AllPokemonBase.self, from: data)
                    promise(.success(allPokemonBase))
                    
                } catch {
                    promise(.failure(.APIError(error)))
                }
            }
            task.resume()
        }
    }
}
