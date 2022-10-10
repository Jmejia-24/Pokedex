//
//  Router.swift
//  Pokedex
//
//  Created by Byron Mejia on 10/9/22.
//

import UIKit

protocol Router: AnyObject {
    associatedtype Route
    var navigationController: UINavigationController { get set }
    func exit()
    func process(route: Route)
}

protocol AppRouter: Router where Route == AppTransition { }
