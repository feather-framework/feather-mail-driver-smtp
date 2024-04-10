//
//  Attachment.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation

/// attachment
public struct Attachment: Sendable {
    /// name
    public let name: String
    /// content type
    public let contentType: String
    /// data
    public let data: Data

    /// attachment init function
    public init(
        name: String,
        contentType: String,
        data: Data
    ) {
        self.name = name
        self.contentType = contentType
        self.data = data
    }
}
