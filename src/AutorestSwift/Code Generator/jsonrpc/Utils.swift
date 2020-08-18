import Foundation
import NIO

public enum ResultType<Value, Type, Method, Error> {
    case success(Value, Type, Method)
    case failure(Error)
}

public enum Framing: CaseIterable {
    case `default`
    case jsonpos
    case brute
}

internal extension NSLock {
    func withLock<T>(_ body: () -> T) -> T {
        lock()
        defer {
            self.unlock()
        }
        return body()
    }
}

internal extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(suffix(toLength))
        }
    }
}
