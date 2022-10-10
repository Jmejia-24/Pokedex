//
//  PastType.swift
//

import Foundation

struct PastType: Codable, Hashable {
    let generation: Generation?
    let types: [Types]?
}
