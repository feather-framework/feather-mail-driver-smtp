//
//  NIOSMTPError.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

/// Errors that can occur during SMTP operations.
enum NIOSMTPError: Error {
    /// Indicates that the recipient of the email is invalid.
    case invalidRecipient
    /// Indicates that the received message is invalid.
    case invalidMessage
    /// Indicates a custom error message.
    case custom(String)
    /// Indicates an unknown error.
    case unknown(Error)
}
