//
//  Transition.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/8/22.
//

import Foundation

protocol TransitionDelegate: AnyObject {
    func process(transition: Transition, with model: Any?)
}

enum Transition {
    case showMainScreen
    case showPokemonDetail
}
