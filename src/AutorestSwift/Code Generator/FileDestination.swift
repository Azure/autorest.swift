//
//  FileDestination.swift
//  
//
//  Created by Travis Prescott on 7/21/20.
//

import Foundation

enum FileDestination {
    case tests
    case root
    case models
    case operations
    case options

    func url(forBaseUrl baseUrl: URL) -> URL {
        switch self {
        case .tests:
            return baseUrl.appendingPathComponent("Tests")
        case .root:
            return baseUrl.appendingPathComponent("Source")
        case .models:
            return baseUrl.appendingPathComponent("Source").appendingPathComponent("Models")
        case .operations:
            return baseUrl.appendingPathComponent("Source").appendingPathComponent("Operations")
        case .options:
            return baseUrl.appendingPathComponent("Source").appendingPathComponent("Options")
        }
    }
}
