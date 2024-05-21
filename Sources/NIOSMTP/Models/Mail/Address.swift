//
//  Address.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

/// A structure representing an email address.
public struct Address: Sendable {

    /// The email address.
    public let address: String
    /// The name associated with the email address.
    public let name: String?

    /// Initializes the Address structure.
    /// - Parameters:
    ///   - address: The email address.
    ///   - name: The name associated with the email address. Default is nil.
    public init(
        _ address: String,
        name: String? = nil
    ) {
        self.address = address
        self.name = name
    }

    /// Returns the MIME representation of the email address.
    var mime: String {
        if let name {
            return "\(name) <\(address)>"
        }
        return address
    }
}
