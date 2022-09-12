//
//  Held.swift
//

import Foundation

struct Held: Codable, Hashable {
    let item: Species?
    let versionDetails: [VersionDetails]?
    
    enum CodingKeys: String, CodingKey {
        case item
        case versionDetails = "version_details"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        item = try values.decodeIfPresent(Species.self, forKey: .item)
        versionDetails = try values.decodeIfPresent([VersionDetails].self, forKey: .versionDetails)
    }
}
