//
//  Mail.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation
import NIO

/// A structure representing an email message.
public struct Mail: Sendable {

    /// The sender's address.
    public let from: Address
    /// The primary recipient addresses.
    public let to: [Address]
    /// The carbon copy recipient addresses.
    public let cc: [Address]
    /// The blind carbon copy recipient addresses.
    public let bcc: [Address]
    /// The reply-to addresses.
    public let replyTo: [Address]
    /// The subject of the email.
    public let subject: String
    /// The body of the email.
    public let body: Body
    /// The reference identifier (optional).
    public let reference: String?
    /// The email attachments.
    public let attachments: [Attachment]

    /// Initializes an email message.
    /// - Parameters:
    ///   - from: The sender's address.
    ///   - to: The primary recipient addresses.
    ///   - cc: The carbon copy recipient addresses. Default is an empty array.
    ///   - bcc: The blind carbon copy recipient addresses. Default is an empty array.
    ///   - replyTo: The reply-to addresses. Default is an empty array.
    ///   - subject: The subject of the email.
    ///   - body: The body of the email.
    ///   - reference: The reference identifier. Default is nil.
    ///   - attachments: The email attachments. Default is an empty array.
    /// - Throws: An error if no valid recipients are provided.
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
