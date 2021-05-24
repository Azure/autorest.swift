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

    fileprivate func generateModels() throws {
        // Simple dictionary (for fast lookup) to determine if a model has already been written.
        // Skips regenerating a file with a less specific schema (Schema vs ObjectSchema, for example)
        // but keeps track of the number of times the model name appears for debugging purposes.
        var modelsWritten = [String: Int]()

        // Create model files
        for object in model.schemas.objects ?? [] {
            let name = object.modelName

            guard modelsWritten[name] == nil else {
                SharedLogger.warn("\(name) has already been generated once this run. Skipping...")
                modelsWritten[name]! += 1
                continue
            }
            let viewModel = ObjectViewModel(from: object)
            try render(
                template: "Model_File",
                toSubfolder: .models,
                withFilename: name,
                andParams: ["model": viewModel]
            )
            modelsWritten[name] = 1

            if let immediates = object.parents?.immediate {
                // render any immediate parents of the object schema
                for parent in immediates {
                    let name = Manager.shared.args!.generateAsInternal.aliasOrName(for: object.name)
                    guard modelsWritten[name] == nil else {
                        SharedLogger.warn("\(name) has already been generated once this run. Skipping...")
                        modelsWritten[name]! += 1
                        continue
                    }
                    guard let parentSchema = parent as? ObjectSchema else {
                        fatalError("Expected ObjectSchema but found \(type(of: parent))")
                    }
                    let viewModel = ObjectViewModel(from: parentSchema)
                    try render(
                        template: "Model_File",
                        toSubfolder: .models,
                        withFilename: name,
                        andParams: ["model": viewModel]
                    )
                    modelsWritten[name] = 1
                }
            }
        }

        // Create group model files
        for group in model.schemas.groups ?? [] {
            let name = Manager.shared.args!.generateAsInternal.aliasOrName(for: group.name)
            guard modelsWritten[name] == nil else {
                SharedLogger.warn("\(name) has already been generated once this run. Skipping...")
                modelsWritten[name]! += 1
                continue
            }
            let viewModel = ObjectViewModel(from: group)
            try render(
                template: "Model_File",
                toSubfolder: .models,
                withFilename: name,
                andParams: ["model": viewModel]
            )
            modelsWritten[name] = 1
        }
    }

    /// Begin code generation process
    func generate() throws {
        let modelUrl = baseUrl.with(subfolder: .models)
        let optionsUrl = baseUrl.with(subfolder: .options)
        let utilUrl = baseUrl.with(subfolder: .util)
        let jazzyUrl = baseUrl.with(subfolder: .jazzy)

        // clear the generated folder to ensure renames are caught
        if let outputFolder = Manager.shared.args?.outputFolder {
            let generatedUrl = URL(fileURLWithPath: outputFolder).with(subfolder: .generated)
            try? FileManager.default.removeItem(at: generatedUrl)
        }

        try modelUrl.ensureExists()
        try optionsUrl.ensureExists()
        try utilUrl.ensureExists()
        try jazzyUrl.ensureExists()
        SharedLogger.info("Base URL: \(baseUrl.path)")

        // Create PatchUtil.swift file
        try render(
            template: "PatchUtil_File",
            toSubfolder: .util,
            withFilename: "PatchUtil",
            andParams: [:]
        )

        // Create Enumerations.swift file
        let enumViewModel = EnumerationFileViewModel(from: model.schemas)
        if enumViewModel.enums.count > 0 {
            try render(
                template: "Enumeration_File",
                toSubfolder: .models,
                withFilename: "Enumerations",
                andParams: ["models": enumViewModel]
            )
        }

        try generateModels()

        // Create Client.swift file
        let clientViewModel = ServiceClientFileViewModel(from: model)
        try render(
            template: "Client_File",
            toSubfolder: .generated,
            withFilename: clientViewModel.name,
            andParams: [
                "model": clientViewModel
            ]
        )

        // Create ClientMethodOptions.swift file
        for operationGroup in clientViewModel.operationGroups {
            try renderClientMethodOptionsFile(for: operationGroup, using: "Method_Options_File")
        }

        // Create ClientOperationGroup.swift file for each operation group with name
        for (groupName, operationGroup) in clientViewModel.namedOperationGroups {
            try render(
                template: "Named_OperationGroup_File",
                toSubfolder: .generated,
                withFilename: "\(groupName)",
                andParams: ["model": clientViewModel, "group": operationGroup]
            )
            // TODO: Find alternative to resolve naming conflicts
            try renderClientMethodOptionsFile(for: operationGroup, with: groupName, using: "Method_Options_File")
        }

        // Create ClientOptions.swift file
        let optionsFileViewModel = ClientOptionsFileViewModel(from: model)
        try render(
            template: "Client_Options_File",
            toSubfolder: .options,
            withFilename: optionsFileViewModel.name,
            andParams: ["model": optionsFileViewModel]
        )

        if !exists(filename: "README.md", inSubfolder: .root) {
            // Create README.md file
            let readmeViewModel = ReadmeFileViewModel(from: model)
            try render(
                template: "README_File",
                toSubfolder: .root,
                withFilename: "README.md",
                andParams: ["model": readmeViewModel]
            )
        }

        if !exists(filename: "Custom.swift", inSubfolder: .source) {
            // Create Custom.swift file, which allows us to wipe and
            // re-generate the Generated folder.
            try render(
                template: "Custom_File",
                toSubfolder: .source,
                withFilename: "Custom.swift",
                andParams: ["": ""]
            )
        }

        // Create Package.swift file
        if !exists(filename: "Package.swift", inSubfolder: .root) {
            let packageViewModel = PackageFileViewModel(from: model)
            try render(
                template: "Package_File",
                toSubfolder: .root,
                withFilename: "Package.swift",
                andParams: ["model": packageViewModel]
            )

            // Create Jazzy config file
            try render(
                template: "Jazzy_File",
                toSubfolder: .jazzy,
                withFilename: "\(model.packageName).yml",
                andParams: ["model": packageViewModel]
            )
        }
    }

    private func exists(filename: String, inSubfolder subfolder: FileDestination) -> Bool {
        let destRoot: URL
        // When using autorest, we must check the output folder for existence of the file, not
        // the temp directory (which will obviously never contain the file!).
        if let outputFolder = Manager.shared.args?.outputFolder {
            destRoot = URL(fileURLWithPath: outputFolder)
        } else {
            destRoot = baseUrl
        }
        let fname = filename.lowercased().contains(".") ? filename : "\(filename).swift"
        let fileUrl = destRoot.with(subfolder: subfolder).appendingPathComponent(fname)
        let result = FileManager.default.fileExists(atPath: fileUrl.path)
        return result
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
        with _: String? = nil,
        using template: String
    ) throws {
        for operation in operationGroup.operations {
            let clientMethodOptions = operation.clientMethodOptions
            var fileName = ""
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
