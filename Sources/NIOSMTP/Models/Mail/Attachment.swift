//
//  Attachment.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation

/// A structure representing an email attachment.
public struct Attachment: Sendable {
    /// The name of the attachment.
    public let name: String
    /// The content type of the attachment.
    public let contentType: String
    /// The data of the attachment.
    public let data: Data

    /// Initializes the Attachment structure.
    /// - Parameters:
    ///   - name: The name of the attachment.
    ///   - contentType: The content type of the attachment.
    ///   - data: The data of the attachment.
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
