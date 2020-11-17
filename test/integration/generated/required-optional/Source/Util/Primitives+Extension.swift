import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

extension Int: LocalizedError {
    public var errorDescription: String? { return String(self) }
}

extension Int32: LocalizedError {
    public var errorDescription: String? { return String(self) }
}

extension Int64: LocalizedError {
    public var errorDescription: String? { return String(self) }
}

extension Data {
    func base64URLEncodedString() -> String {
        let base64String = base64EncodedString()
        let base64UrlString = base64String.replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
        return base64UrlString
    }
}
<<<<<<< HEAD

extension String {
    func decimal(_ codingPath: [CodingKey], key: CodingKey) throws -> Decimal {
        guard let decimal = Decimal(string: self) else {
            throw DecodingError
                .dataCorrupted(.init(
                    codingPath: codingPath,
                    debugDescription: "The key \(key) could not be converted to decimal: \(self)"
                ))
        }
        return decimal
    }
}

extension KeyedEncodingContainer {
    mutating func encode(_ value: Decimal, forKey key: K) throws {
        try encode(String(describing: value), forKey: key)
    }

    mutating func encodeIfPresent(_ value: Decimal?, forKey key: K) throws {
        guard let value = value else { return }
        try encode(value, forKey: key)
    }
}

extension KeyedDecodingContainer {
    func decode(_: Decimal.Type, forKey key: K) throws -> Decimal {
        try decode(String.self, forKey: key).decimal(codingPath, key: key)
    }

    func decodeIfPresent(_: Decimal.Type, forKey key: K) throws -> Decimal? {
        try decodeIfPresent(String.self, forKey: key)?.decimal(codingPath, key: key)
    }
}
=======
>>>>>>> master
