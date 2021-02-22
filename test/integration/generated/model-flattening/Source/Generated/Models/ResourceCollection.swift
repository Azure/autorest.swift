// --------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// --------------------------------------------------------------------------

import AzureCore
import Foundation
// swiftlint:disable superfluous_disable_command
// swiftlint:disable identifier_name
// swiftlint:disable line_length
// swiftlint:disable cyclomatic_complexity

public struct ResourceCollection: Codable {
    // MARK: Properties

    /// Flattened product.
    public let productresource: FlattenedProduct?

    public let arrayofresources: [FlattenedProduct]?
    /// Dictionary of <FlattenedProduct>
    public let dictionaryofresources: [String: FlattenedProduct?]?

    // MARK: Initializers

    /// Initialize a `ResourceCollection` structure.
    /// - Parameters:
    ///   - productresource: Flattened product.
    ///   - arrayofresources:
    ///   - dictionaryofresources: Dictionary of <FlattenedProduct>
    public init(
        productresource: FlattenedProduct? = nil, arrayofresources: [FlattenedProduct]? = nil,
        dictionaryofresources: [String: FlattenedProduct?]? = nil
    ) {
        self.productresource = productresource
        self.arrayofresources = arrayofresources
        self.dictionaryofresources = dictionaryofresources
    }

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case productresource = "productresource"
        case arrayofresources = "arrayofresources"
        case dictionaryofresources = "dictionaryofresources"
    }

    /// Initialize a `ResourceCollection` structure from decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productresource = try? container.decode(FlattenedProduct.self, forKey: .productresource)
        self.arrayofresources = try? container.decode([FlattenedProduct].self, forKey: .arrayofresources)
        self.dictionaryofresources = try? container.decode(
            [String: FlattenedProduct?].self,
            forKey: .dictionaryofresources
        )
    }

    /// Encode a `ResourceCollection` structure
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if productresource != nil { try? container.encode(productresource, forKey: .productresource) }
        if arrayofresources != nil { try? container.encode(arrayofresources, forKey: .arrayofresources) }
        if dictionaryofresources != nil { try? container.encode(dictionaryofresources, forKey: .dictionaryofresources) }
    }
}
