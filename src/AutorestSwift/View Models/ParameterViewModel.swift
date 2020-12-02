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

/// View Model for an operation parameter.
/// /// Operation description.
/// /// - Parameters:
/// ///  {name}: {comment}
/// public func method(
///   {name}: {type}{defaultValue},
/// ) {
///    // Construct URL
///    let urlTemplate = ""
///    let params = RequestParameters(
///        (.{location}, {serializedName}, {pathOrValue}, .{encode})
///    )
struct ParameterViewModel {
    /// Name of the parameter
    var name: String

    /// The name or key that should be sent over the wire
    var serializedName: String

    /// The value or variable path to the value of the parameter
    var pathOrValue: String

    /// Swift type annotation, including optionality, if applicable
    var type: String

    /// Swift type annotation used for constructing models
    let modelName: String

    /// Describes whether the field is optional
    var optional: Bool

    /// Default value for the parameter
    var defaultValue: ViewModelDefault

    /// Comment value for the parameter
    var comment: ViewModelComment

    /// Where the parameter goes in terms of the request
    var location: String

    /// Whether to URL encode the parameter or not
    let encode: String

    // MARK: Initializers

    init(
        name: String,
        serializedName: String,
        pathOrValue: String,
        type: String,
        optional: Bool,
        defaultValue: ViewModelDefault,
        comment: ViewModelComment,
        location: String,
        encode: String
    ) {
        self.name = name
        self.serializedName = serializedName
        self.pathOrValue = pathOrValue
        self.type = type
        self.modelName = type.hasSuffix("?") ? String(type.dropLast()) : type
        self.optional = optional
        self.defaultValue = defaultValue
        self.comment = comment
        self.location = location
        self.encode = encode
    }

    init(from param: ParameterType, with operation: Operation? = nil) {
        let optional = !param.required
        self.init(
            name: param.variableName,
            serializedName: param.serializedName ?? param.name,
            pathOrValue: "",
            type: param.schema.swiftType(optional: optional),
            optional: optional,
            defaultValue: ViewModelDefault(from: param.clientDefaultValue, isString: true, isOptional: optional),
            comment: ViewModelComment(from: param.description),
            location: param.paramLocation?.rawValue ?? "???",
            encode: param.value.isSkipUrlEncoding ? "skipEncoding" : "encode"
        )

        if let constantSchema = param.schema as? ConstantSchema {
            update(withParam: param, andConstantSchema: constantSchema)
        } else if let signatureParameter = operation?.signatureParameter(for: param.name) {
            update(withSignatureParameter: signatureParameter)
        } else if let groupedBy = param.groupedBy?.name {
            self.pathOrValue = "\(groupedBy).\(param.name)"
        } else if param.implementation == .client {
            if ["$host", "endpoint"].contains(name) {
                self.pathOrValue = "client.endpoint.absoluteString"
            } else {
                self.pathOrValue = "client.\(name)"
            }
        } else if let op = operation, param.paramLocation == .body {
            let bodyParamName = op.request?.bodyParamName(for: op)
            update(withBodySignatureParameter: param, andBodyParamName: bodyParamName)
        } else {
            // assertionFailure("Unexpected scenario in ParameterViewModel")
            self.pathOrValue = "???"
        }
    }

    private mutating func update(withSignatureParameter param: ParameterType) {
        assert(!(param.serializedName?.isEmpty ?? true))
        pathOrValue = param.belongsInOptions() ? "options?.\(name)" : "\(name)"
    }

    private mutating func update(withParam param: ParameterType, andConstantSchema constant: ConstantSchema) {
        pathOrValue = constant.formatValue(
            skipUrlEncoding: param.value.isSkipUrlEncoding,
            paramLocation: param.paramLocation
        )
    }

    private mutating func update(withBodySignatureParameter param: ParameterType, andBodyParamName name: String?) {
        let key = name ?? param.name
        pathOrValue = param.belongsInOptions() ? "options?.\(key)" : "\(key)"
    }

    static func < (lhs: ParameterViewModel, rhs: ParameterViewModel) -> Bool {
        return lhs.name.caseInsensitiveCompare(rhs.name) == .orderedAscending
    }
}
