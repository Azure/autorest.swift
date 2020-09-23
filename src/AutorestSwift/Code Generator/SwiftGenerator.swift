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

    // MARK: Initializers

    init(withModel model: CodeModel, atBaseUrl baseUrl: URL) {
        self.model = model
        self.baseUrl = baseUrl
    }

    // MARK: Methods

    /// Begin code generation process
    func generate() throws {
        let modelUrl = baseUrl.with(subfolder: .models)
        let optionsUrl = baseUrl.with(subfolder: .options)
        let utilUrl = baseUrl.with(subfolder: .util)
        let jazzyUrl = baseUrl.with(subfolder: .jazzy)
        try modelUrl.ensureExists()
        try optionsUrl.ensureExists()
        try utilUrl.ensureExists()
        try jazzyUrl.ensureExists()
        SharedLogger.info("Base URL: \(baseUrl.path)")

        // Create PatchUtil.swift file
        try render(
            template: "PatchUtilFile",
            toSubfolder: .util,
            withFilename: "PatchUtil",
            andParams: [:]
        )
        // Create Primitives+Extension.swift file
        try render(
            template: "Primitives+ExtensionFile",
            toSubfolder: .util,
            withFilename: "Primitives+Extension",
            andParams: [:]
        )

        // Create Enumerations.swift file
        let enumViewModel = EnumerationFileViewModel(from: model.schemas)
        if enumViewModel.enums.count > 0 {
            try render(
                template: "EnumerationFile",
                toSubfolder: .models,
                withFilename: "Enumerations",
                andParams: ["models": enumViewModel]
            )
        }

        // Create model files
        for object in model.schemas.objects ?? [] {
            let structViewModel = ObjectViewModel(from: object)
            try render(
                template: "ModelFile",
                toSubfolder: .models,
                withFilename: object.name,
                andParams: ["model": structViewModel]
            )
        }

        // Create Client.swift file
        let clientViewModel = ServiceClientFileViewModel(from: model)
        try render(
            template: "ServiceClientFile",
            toSubfolder: .source,
            withFilename: clientViewModel.name,
            andParams: [
                "model": clientViewModel
            ]
        )

        // Render OperationGroup in Client.swift file
        for operationGroup in clientViewModel.operationGroups {
            try render(for: operationGroup)
        }

        // Create ClientKeyOperationGroup.swift file
        for (key, operationGroup) in clientViewModel.keyOperationGroups {
            try render(
                template: "KeyOperationGroupFile",
                toSubfolder: .source,
                withFilename: "\(key)",
                andParams: ["model": clientViewModel, "group": operationGroup]
            )
            try render(for: operationGroup, key: key)
        }

        // Create ClientOptions.swift file
        try render(
            template: "ClientOptionsFile",
            toSubfolder: .options,
            withFilename: "\(clientViewModel.name)Options",
            andParams: ["model": clientViewModel]
        )

        // Create README.md file
        let readmeViewModel = ReadmeFileViewModel(from: model)
        try render(
            template: "README",
            toSubfolder: .root,
            withFilename: "README.md",
            andParams: ["model": readmeViewModel]
        )

        // Create Package.swift file
        let packageViewModel = PackageFileViewModel(from: model)
        try render(
            template: "Package",
            toSubfolder: .root,
            withFilename: "Package.swift",
            andParams: ["model": packageViewModel]
        )

        // Create Jazzy config file
        try render(
            template: "JazzyFile",
            toSubfolder: .jazzy,
            withFilename: "\(model.packageName).yml",
            andParams: ["model": packageViewModel]
        )
    }

    private func render(
        template: String,
        toSubfolder subfolder: FileDestination,
        withFilename filename: String,
        andParams params: [String: Any]
    ) throws {
        let tname = template.lowercased().hasSuffix(".stencil") ? template : "\(template).stencil"
        let fileContent = try renderTemplate(filename: tname, dictionary: params)
        let fname = filename.lowercased().contains(".") ? filename : "\(filename).swift"
        let fileUrl = baseUrl.with(subfolder: subfolder).appendingPathComponent(fname)
        try fileContent.write(to: fileUrl, atomically: true, encoding: .utf8)
    }

    fileprivate func render(for operationGroup: OperationGroupViewModel, key: String? = nil) throws {
        for operation in operationGroup.operations {
            let clientMethodOptions = operation.clientMethodOptions
            var fileName: String
            if let k = key {
                fileName = "\(k.capitalized + "." + clientMethodOptions.name.capitalized).swift"
            } else {
                fileName = "\(clientMethodOptions.name.capitalized).swift"
            }

            try render(
                template: "ClientMethodOptionsFile",
                toSubfolder: .options,
                withFilename: fileName,
                andParams: ["model": clientMethodOptions]
            )
        }
    }
}
