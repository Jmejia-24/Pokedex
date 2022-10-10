//
//  AppTransition.swift
//  Pokedex
//
//  Created by Byron Mejia on 10/9/22.
//

import Foundation

enum AppTransition {
    
    case showMainScreen
    case showPokemonDetail(model: Pokemon)
    
    var hasState: Bool {
        // If some transitions need to have state - perform case match logic here
        // Generally prefer stateless
        false
    }
    
    func coordinatorFor<R: AppRouter>(router: R) -> Coordinator {
        switch self {
        case .showMainScreen: return PokemonListCoordinator(router: router)
        case .showPokemonDetail(let model): return PokemonDetailCoordinator(model: model, router: router)
        }
    }
}

extension AppTransition: Hashable {
    
    var identifier: String {
        switch self {
        case .showMainScreen: return "showMainScreen"
        case .showPokemonDetail: return "showDetail"
        }
    }
    
    static func == (lhs: AppTransition, rhs: AppTransition) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
