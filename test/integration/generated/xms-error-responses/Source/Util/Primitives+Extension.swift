import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

extension Int: LocalizedError {
    public var errorDescription: String? { return String(self) }
}
