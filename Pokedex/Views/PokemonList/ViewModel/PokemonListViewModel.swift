//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/8/22.
//

import UIKit
import Combine
import OrderedCollections

protocol PokemonListViewModelRepresentable {
    func loadData(_ offset: Int)
    func searchPokemon(with query: String?)
    func prefetchData(for indexPaths: [IndexPath])
    func didTapItem(model: Pokemon)
    var pokemonListSubject: PassthroughSubject<[Pokemon], Failure> { get }
}

final class PokemonListViewModel<R: AppRouter> {
    var router: R?
    let pokemonListSubject = PassthroughSubject<[Pokemon], Failure>()
    private var cancellables = Set<AnyCancellable>()
    private let store: PokemonListStore
    
    private var fetchedBase: AllPokemonBase?
    
    private var fetchedPokemon = OrderedSet([Pokemon]()) {
        didSet {
            pokemonListSubject.send(fetchedPokemon.elements)
        }
    }
    
    init(store: PokemonListStore = APIManager()) {
        self.store = store
    }
}

extension PokemonListViewModel: PokemonListViewModelRepresentable {
    func loadData(_ offset: Int) {
        let recievedPokemons = { [unowned self] (newPokemonBase: AllPokemonBase) -> Void in
            fetchedBase = newPokemonBase
            DispatchQueue.main.async {
                self.fetchedPokemon.append(contentsOf: newPokemonBase.results)
            }
        }
        
        let completion = { [unowned self] (completion: Subscribers.Completion<Failure>) -> Void in
            switch  completion {
            case .finished:
                break
            case .failure(let failure):
                pokemonListSubject.send(completion: .failure(failure))
            }
        }
        
        store.readPokemonList(offset: offset)
            .sink(receiveCompletion: completion, receiveValue: recievedPokemons)
            .store(in: &cancellables)
    }
    
    func searchPokemon(with query: String?) {
        if let query = query, !query.isEmpty {
            let lowerCaseQuery = query.lowercased()
            let filteredPokemonList = fetchedPokemon.elements.filter { $0.name.lowercased().contains(lowerCaseQuery) }
            pokemonListSubject.send(filteredPokemonList)
        } else {
            pokemonListSubject.send(fetchedPokemon.elements)
        }
    }
    
    func prefetchData(for indexPaths: [IndexPath]) {
        guard let index = indexPaths.last?.row else { return }
        
        let pokemonAlreadyLoaded = fetchedPokemon.count
        if index > pokemonAlreadyLoaded - 10 {
            loadData(pokemonAlreadyLoaded)
        }
    }
    
    func didTapItem(model: Pokemon) {
        router?.process(route: .showPokemonDetail(model: model))
    }
}
