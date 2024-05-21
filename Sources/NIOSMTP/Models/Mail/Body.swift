//
//  Body.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 20/11/2023.
//

/// An enumeration representing the body of an email.
public enum Body: Sendable {
    /// Plain text body.
    case plainText(String)
    /// HTML formatted body.
    case html(String)
}
