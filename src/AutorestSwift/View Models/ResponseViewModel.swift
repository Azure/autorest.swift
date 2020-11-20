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
    /// Service returns a pageable response
    case pagedBody
    /// Service returns no response data, only a status code
    case noBody
    /// Service returns a String
    case stringBody
    /// Service returns an Int
    case intBody
    /// Service returns a JSON body
    case jsonBody
    /// Service returns a unixTime body
    case unixTimeBody
    /// Service returns a byteArray body
    case byteArrayBody

    case dateBody
    case dateTimeBody
    case datetimeRfc1123Body

    static func strategy(for input: String, and type: AllSchemaTypes, schema: Schema) -> ResponseBodyType {
        if input == "String" {
            return .stringBody
        } else if input.starts(with: "Int") {
            return .intBody
        } else if input == "Date" {
            switch type {
            case .unixTime:
                return .unixTimeBody
            case .date:
                return .dateBody
            case .dateTime:
                if let dateTimeSchema = schema as? DateTimeSchema,
                    dateTimeSchema.format == .dateTimeRfc1123 {
                    return .datetimeRfc1123Body
                }
                return .dateTimeBody
            default:
                return .dateBody
            }
        } else if input == "Data", type == .byteArray {
            return .byteArrayBody
        } else {
            return .jsonBody
        }
    }
}

/// View Model for method response handling.
struct ResponseViewModel {
    let statusCodes: [String]
    let objectType: String
    /// Identifies the correct snippet to use when rendering the view model
    let strategy: String
    let pagingNames: Language.PagingNames?
    let pagedElementClassName: String?
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
            guard arrayElements.count == 1 else { fatalError("Did not find exactly one array type for paged collection.") }
            self.strategy = ResponseBodyType.pagedBody.rawValue
            self.pagingNames = pagingNames
            self.pagedElementClassName = arrayElements.first!.elementType.name

            if let elementType = pagedElementClassName, self.pagingNames != nil {
                self.objectType = "PagedCollection<\(elementType)>"
            } else {
                self.objectType = schemaResponse?.schema.swiftType(optional: false) ?? "Void"
            }
        } else {
            self.pagingNames = nil
            self.pagedElementClassName = nil
            if let objectType = schemaResponse?.schema.swiftType(optional: false),
                let type = schemaResponse?.schema.type,
                let schema = schemaResponse?.schema {
                self.strategy = ResponseBodyType.strategy(for: objectType, and: type, schema: schema).rawValue
                self.objectType = objectType
            } else {
                self.strategy = ResponseBodyType.noBody.rawValue
                self.objectType = "Void"
            }
        }
    }
}
