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
            let viewModel = ObjectViewModel(from: object)
            try render(
                template: "ModelFile",
                toSubfolder: .models,
                withFilename: object.name,
                andParams: ["model": viewModel]
            )

            if let immediates = object.parents?.immediate {
                // render any immediate parents of the object schema
                for parent in immediates {
                    let viewModel = ObjectViewModel(from: parent)
                    try render(
                        template: "ModelFile",
                        toSubfolder: .models,
                        withFilename: parent.name,
                        andParams: ["model": viewModel]
                    )
                }
            }
        }

        // Create group model files
        for group in model.schemas.groups ?? [] {
            let viewModel = ObjectViewModel(from: group)
            try render(
                template: "ModelFile",
                toSubfolder: .models,
                withFilename: group.name,
                andParams: ["model": viewModel]
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

        // Create ClientMethodOptions.swift file
        for operationGroup in clientViewModel.operationGroups {
            try renderClientMethodOptionsFile(for: operationGroup, using: "ClientMethodOptionsFile")
        }

        // Create ClientOperationGroup.swift file for each operation group with name
        for (groupName, operationGroup) in clientViewModel.namedOperationGroups {
            try render(
                template: "NamedOperationGroupFile",
                toSubfolder: .source,
                withFilename: "\(groupName)",
                andParams: ["model": clientViewModel, "group": operationGroup]
            )
            try renderClientMethodOptionsFile(for: operationGroup, with: groupName, using: "NamedMethodOptionsFile")
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

    private func renderClientMethodOptionsFile(
        for operationGroup: OperationGroupViewModel,
        with groupName: String? = nil,
        using template: String
    ) throws {
        for operation in operationGroup.operations {
            let clientMethodOptions = operation.clientMethodOptions
            var fileName = ""
            if let groupName = groupName {
                fileName = "\(groupName + "+")"
            }

            fileName += "\(clientMethodOptions.name).swift"

            try render(
                template: template,
                toSubfolder: .options,
                withFilename: fileName,
                andParams: ["model": clientMethodOptions]
            )
        }
    }
}
