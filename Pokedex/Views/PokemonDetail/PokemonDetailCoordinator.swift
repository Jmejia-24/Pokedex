//
//  PokemonDetailCoordinator.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/12/22.
//

import UIKit

final class PokemonDetailCoordinator<R: AppRouter> {
    var model: Pokemon
    let router: R
    
    var primaryViewController: UIViewController {
        let viewModel = PokemonDetailViewModel(pokemon: model)
        let detailViewController = PokemonDetailViewController(viewModel: viewModel)
        return detailViewController
    }
    
    init(model: Pokemon, router: R) {
        self.model = model
        self.router = router
    }
}

extension PokemonDetailCoordinator: Coordinator {
    func start() {
        router.navigationController.pushViewController(primaryViewController, animated: true)
    }
}
