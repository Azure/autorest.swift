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

/// Class used to generate Swift code
class SwiftGenerator: CodeGenerator {
    // MARK: Properties

    let model: CodeModel

    let baseUrl: URL

    var allEnums: [String] = []
    var allStructs: [String] = []

    // MARK: Initializers

    init(withModel model: CodeModel, atBaseUrl baseUrl: URL) {
        self.model = model
        self.baseUrl = baseUrl
    }

    // MARK: Methods

    /// Begin code generation process
    func generate() throws {
        // TODO: Begin code generation process
        try generateSchemas()

        try createModelFiles()
    }

    private func generateSchemas() throws {
        let modelUrl = baseUrl.with(subfolder: .models)
        try modelUrl.ensureExists()

        // Create Enumerations.swift file
        if let choices = model.schemas.choices {
            generateSnippetFromTemplate(stencilables: choices, results: &allEnums)
        }

        if let objects = model.schemas.objects {
            generateSnippetFromTemplate(stencilables: objects, results: &allStructs)
        }
    }

    private func generateSnippetFromTemplate(stencilables: [Stencilable], results: inout [String]) {
        for stencilable in stencilables {
            do {
                results.append(try stencilable.generateSnippet())
            } catch {
                print(error)
            }
        }
    }

    private func createModelFiles() throws {
        let fileContent = try renderTemplate(
            filename: "ModelFile.stencil",
            dictionary: ["allEnums": allEnums, "allStructs": allStructs]
        )

        let modelUrl = baseUrl.with(subfolder: .models).appendingPathComponent("Model.swift")
        try fileContent.write(to: modelUrl, atomically: true, encoding: .utf8)
    }
}
