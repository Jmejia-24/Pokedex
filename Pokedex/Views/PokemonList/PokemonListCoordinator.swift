//
//  PokemonListCoordinator.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/8/22.
//

import UIKit

final class PokemonListCoordinator: Coordinator {

    var model: Any?
    var navigationController: UINavigationController?
    weak var transitionDelegate: TransitionDelegate?
    
    private lazy var primaryViewController: UIViewController = {
        let viewModel = PokemonListViewModel()
        viewModel.transitionDelegate = transitionDelegate
        let viewController = PokemonListViewController(viewModel: viewModel)
        return viewController
    }()
    
    func start() {
        if navigationController?.viewControllers.isEmpty == false {
            navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(primaryViewController, animated: false)
    }
}
