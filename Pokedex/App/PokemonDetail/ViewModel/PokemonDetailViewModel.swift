//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/12/22.
//

import UIKit
import Combine

final class PokemonDetailViewModel {
    let pokemon: Pokemon
    let store: PokemonDetailStore
    var detail: PokemonDetailBase?
    
    let pokemonDetailSubject = CurrentValueSubject<PokemonDetailBase?, Failure>(nil)
    
    private var disposeBag = Set<AnyCancellable>()
    
    init(pokemon: Pokemon, store: PokemonDetailStore = APIManager()) {
        self.pokemon = pokemon
        self.store = store
    }
    
    func loadData() {

        let recievedPokemons = { [unowned self] (fetchedPokemonDetails: PokemonDetailBase) -> Void in
            DispatchQueue.main.async {
                pokemonDetailSubject.send(fetchedPokemonDetails)
            }
        }
        
        let completion = { [unowned self] (completion: Subscribers.Completion<Failure>) -> Void in
            switch completion {
            case .finished:
                break
            case .failure(let failure):
                pokemonDetailSubject.send(completion: .failure(failure))
            }
        }

        store.readPokemonDetails(for: pokemon)
            .sink(receiveCompletion: completion, receiveValue: recievedPokemons)
            .store(in: &disposeBag)
    }
}
