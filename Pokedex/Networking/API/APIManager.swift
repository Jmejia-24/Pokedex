//
//  APIManager.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/8/22.
//

import UIKit
import Combine

protocol PokemonListStore {
    func readPokemonList(offset: Int) -> Future<AllPokemonBase, Failure>
}

protocol PokemonDetailStore {
    func readPokemonDetails(for pokemon: Pokemon) -> Future<PokemonDetailBase, Failure>
}

final class APIManager {
    static let serviceURL = "https://pokeapi.co/api/v2/"
    
    static func fetchImage(imageURL: String) async throws -> UIImage {
        
        guard let url = URL(string: imageURL) else { throw Failure.urlConstructError }
        
        do {
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard
                let statusCode = (response as? HTTPURLResponse)?.statusCode,
                let image = UIImage(data: data), 200...299 ~= statusCode else { throw Failure.statusCode }
            return image
            
        } catch {
            throw error
        }
    }
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

extension APIManager: PokemonDetailStore {
    
    func readPokemonDetails(for pokemon: Pokemon) -> Future<PokemonDetailBase, Failure> {
        return Future { promise in
            guard let url = URL(string: pokemon.url) else {
                promise(.failure(.urlConstructError))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard let data = data, case .none = error else { promise(.failure(.urlConstructError)); return }
                do {
                    let decoder = JSONDecoder()
                    let pokemonDetailBase = try decoder.decode(PokemonDetailBase.self, from: data)
                    promise(.success(pokemonDetailBase))
                } catch {
                    promise(.failure(.APIError(error)))
                }
            }
            task.resume()
        }
    }
}
