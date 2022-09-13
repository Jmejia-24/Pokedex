//
//  Localization.swift
//  Pokedex
//
//  Created by Byron Mejia on 9/13/22.
//

import Foundation

protocol Localization {
    associatedtype Key
    func localizedString(_ key: Key) -> String
}
