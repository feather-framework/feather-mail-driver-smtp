//
//  Mail.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation
import NIO

/// mail object
public struct Mail: Sendable {

    /// from
    public let from: Address
    /// to
    public let to: [Address]
    /// cc
    public let cc: [Address]
    /// bcc
    public let bcc: [Address]
    /// reply to
    public let replyTo: [Address]
    /// subject
    public let subject: String
    /// body
    public let body: Body
    /// reference
    public let reference: String?
    /// attachments
    public let attachments: [Attachment]

    /// mail init function
    public init(
        from: Address,
        to: [Address],
        cc: [Address] = [],
        bcc: [Address] = [],
        replyTo: [Address] = [],
        subject: String,
        body: Body,
        reference: String? = nil,
        attachments: [Attachment] = []
    ) throws {
        guard !to.isEmpty || !cc.isEmpty || !bcc.isEmpty else {
            throw NIOSMTPError.invalidRecipient
        }
        self.from = from
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.subject = subject
        self.body = body
        self.replyTo = replyTo
        self.reference = reference
        self.attachments = attachments
    }
}
