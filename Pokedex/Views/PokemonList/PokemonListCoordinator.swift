//
//  PokemonListCoordinator.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/8/22.
//

import UIKit

final class PokemonListCoordinator<R: AppRouter> {
    let router: R
    
    private lazy var primaryViewController: UIViewController = {
        let viewModel = PokemonListViewModel<R>()
        viewModel.router = router
        let viewController = PokemonListViewController(viewModel: viewModel)
        return viewController
    }()
    
    init(router: R) {
        self.router = router
    }
}

extension PokemonListCoordinator: Coordinator {
    func start() {
        router.navigationController.pushViewController(primaryViewController, animated: false)
    }
}
