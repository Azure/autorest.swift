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

enum MergePatchOpType: String, Codable {
    case add
    case remove
    case replace
    case move
    case copy
    case test
}

// TODO: NO support for nil-setting sentinel

struct MergePatchOperation: Encodable {
    let operation: MergePatchOpType
    let from: String?
    let path: String
    let value: String?

    // MARK: Encodable

    enum CodingKeys: String, CodingKey {
        case operation, from, path, value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(operation, forKey: .operation)
        try container.encode(from, forKey: .from)
        try container.encode(path, forKey: .path)
        try container.encode(value, forKey: .value)
    }
}

/// Helper class for creating PatchObjects
final class MergePatchObject: Encodable {
    fileprivate var operations = [MergePatchOperation]()

    /// Inserts a new value at an array index or adds a new property.
    func add(atPath path: String, withValue value: String) {
        operations.append(MergePatchOperation(operation: .add, from: nil, path: path, value: value))
    }

    /// Remove the property or entry at an array index. Property must exist.
    func remove(atPath path: String) {
        operations.append(MergePatchOperation(operation: .remove, from: nil, path: path, value: nil))
    }

    /// Replaces the value at the target location with a new value. Existing value must exist.
    func replace(atPath path: String, withValue value: String) {
        operations.append(MergePatchOperation(operation: .replace, from: nil, path: path, value: value))
    }

    /// Remove the value at a specified location and adds it to the target location.
    func move(fromPath src: String, toPath dest: String) {
        operations.append(MergePatchOperation(operation: .move, from: src, path: dest, value: nil))
    }

    /// Copies the value at a specified location and adds it to the target location.
    func copy(fromPath src: String, toPath dest: String) {
        operations.append(MergePatchOperation(operation: .copy, from: src, path: dest, value: nil))
    }

    /// Tests that a value at the target location is equal to a specified value.
    func test(atPath path: String, equalsValue value: String) {
        operations.append(MergePatchOperation(operation: .test, from: nil, path: path, value: value))
    }
}
