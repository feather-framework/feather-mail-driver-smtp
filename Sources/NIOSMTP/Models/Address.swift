//
//  Address.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

public struct Address {
    public let address: String
    public let name: String?

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
