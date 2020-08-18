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
import NIO
import os.log

guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
    fatalError("Unabled to locate Documents directory.")
}

// Load yaml file
let sourceUrl = documentsUrl.appendingPathComponent("code-model-v4-2.yaml")
let manager = Manager(withInputUrl: sourceUrl, destinationUrl: documentsUrl)
do {
    try manager.run()
} catch {
    print(error)
}

private let group = DispatchGroup()
let autoRestPlugin = AutoRestPlugin()
let logger = Logger(withFileName: "autorest-swift-debug.log")
do {
    _ = try autoRestPlugin.start().wait()
    logger.logToURL("Starting AutoRest.Swift")
} catch {
    logger.logToURL("Error starting AutoRest.Swift: \(error)")
}

// Check for an OS signal to abort
group.enter()
let signalSource = trap(signal: Signal.INT) { signal in
    logger.logToURL("Intercepted signal: \(signal)")
    // server.stop().whenComplete { _ in
    group.leave()
    // }
}

group.wait()
logger.logToURL("Cleaning up AutoRest.Swift")
signalSource.cancel()

// TODO: Relocate this out of main.swift
private func trap(signal sig: Signal, handler: @escaping (Signal) -> Void) -> DispatchSourceSignal {
    let queue = DispatchQueue(label: "Autorest swift")
    let signalSource = DispatchSource.makeSignalSource(signal: sig.rawValue, queue: queue)
    signal(sig.rawValue, SIG_IGN)
    signalSource.setEventHandler(handler: {
        signalSource.cancel()
        handler(sig)
    })
    signalSource.resume()
    return signalSource
}

// TODO: Relocate this out of main.swift
private enum Signal: Int32 {
    case HUP = 1
    case INT = 2
    case QUIT = 3
    case ABRT = 6
    case KILL = 9
    case ALRM = 14
    case TERM = 15
}
