// --------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the ""Software""), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
// --------------------------------------------------------------------------

import Foundation

enum ResponseBodyType: String {
    /// Returns a deserialized object (most common)
    case plainBody
    /// Service returns a pageable response
    case pagedBody
    /// Service returns no response data, only a status code
    case noBody
    /// Service returns a String
    case stringBody
    /// Service returns an Int
    case intBody
    /// Service returns a unixTime body
    case unixTimeBody
    /// Service returns a byteArray body
    case byteArrayBody

    static func strategy(for input: String, and schema: Schema) -> ResponseBodyType {
        let type = schema.type
        if input == "String" {
            return .stringBody
        } else if input.starts(with: "Int") {
            return .intBody
        } else if input == "Date" {
            switch type {
            case .unixTime:
                return .unixTimeBody
            default:
                return .plainBody
            }
        } else if type == .byteArray {
            return .byteArrayBody
        } else {
            return .plainBody
        }
    }
}

/// View Model for method response handling.
struct ResponseViewModel {
    /// List of allowed response status codes
    let statusCodes: [String]

    /// Swift type annotation, including optionality, if applicable
    let type: String

    /// Identifies the correct snippet to use when rendering the view model
    let strategy: String

    /// The `PagingNames` struct to use when generating paged objects
    let pagingNames: Language.PagingNames?

    /// The type name that belongs inside the `PagedCollection` generic
    let pagedElementType: String?

    /// If `true` the response is nullable
    let isNullable: Bool

    init(from response: Response, with operation: Operation) {
        let httpResponse = response.protocol.http as? HttpResponse
        var statusCodes = [String]()
        httpResponse?.statusCodes.forEach { statusCodes.append($0.rawValue) }

        self.statusCodes = statusCodes

        // check if the request body schema type is object, store the object type of the response body
        let schemaResponse = response as? SchemaResponse

        self.isNullable = schemaResponse?.nullable ?? false
        if let pagingMetadata = operation.extensions?["x-ms-pageable"]?.value as? [String: String],
            let pagingNames = Language.PagingNames(from: pagingMetadata) {
            var arrayElements = (schemaResponse?.schema.properties ?? []).compactMap { $0.schema as? ArraySchema }
            if arrayElements.isEmpty {
                let objectElements = (schemaResponse?.schema.properties ?? []).compactMap { $0.schema as? ObjectSchema }
                for object in objectElements {
                    let objectArrays = (object.properties ?? []).compactMap { $0.schema as? ArraySchema }
                    arrayElements += objectArrays
                }
            }

            // FIXME: This assumption no longer holds for storage and should be revisited
            guard arrayElements.count == 1
            else { fatalError("Did not find exactly one array type for paged collection.") }
            self.strategy = ResponseBodyType.pagedBody.rawValue
            self.pagingNames = pagingNames
            self.pagedElementType = arrayElements.first!.elementType.name

            if let elementType = pagedElementType, self.pagingNames != nil {
                self.type = "PagedCollection<\(elementType)>"
            } else {
                self.type = schemaResponse?.schema.swiftType() ?? "Void"
            }
        } else {
            self.pagingNames = nil
            self.pagedElementType = nil
            if let type = schemaResponse?.schema.swiftType(),
                let schema = schemaResponse?.schema {
                self.strategy = ResponseBodyType.strategy(for: type, and: schema).rawValue
                self.type = type
            } else {
                self.strategy = ResponseBodyType.noBody.rawValue
                self.type = "Void"
            }
        }
    }
}
