//
//  PokemonDetailCoordinator.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/12/22.
//

import UIKit

final class PokemonDetailCoordinator: Coordinator {

    var model: Any?
    var navigationController: UINavigationController?
    weak var transitionDelegate: TransitionDelegate?

    var primaryViewController: UIViewController {
        // NOTE: TREATING THIS MODEL AS DEPENCY WHICH IS WHY FORCE CASTIN HERE
        let viewModel = PokemonDetailViewModel(pokemon: model as! Pokemon)
        let detailViewController = PokemonDetailViewController(viewModel: viewModel)
        return detailViewController
    }

    func start() {
        navigationController?.pushViewController(primaryViewController, animated: true)
    }
}
