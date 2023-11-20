//
//  Attachment.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation

public struct Attachment: Sendable {
    public let name: String
    public let contentType: String
    public let data: Data

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
