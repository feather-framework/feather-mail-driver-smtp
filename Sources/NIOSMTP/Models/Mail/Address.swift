//
//  Address.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

/// address
public struct Address: Sendable {
    /// address
    public let address: String
    /// name
    public let name: String?

    /// address init function
    public init(
        _ address: String,
        name: String? = nil
    ) {
        self.address = address
        self.name = name
    }

    var mime: String {
        if let name {
            return "\(name) <\(address)>"
        }
        return address
    }
}
