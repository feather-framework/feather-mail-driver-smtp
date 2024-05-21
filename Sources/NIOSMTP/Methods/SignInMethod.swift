//
//  SignInMethod.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

/// An enumeration representing sign-in methods for SMTP communication.
public enum SignInMethod: Sendable {
    /// Sign in anonymously.
    case anonymous
    /// Sign in with credentials.
    case credentials(username: String, password: String)
}
