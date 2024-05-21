//
//  Configuration.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO

/// A structure representing SMTP configuration.
public struct Configuration: Sendable {
    /// The hostname of the SMTP server.
    public let hostname: String
    /// The port number of the SMTP server.
    public let port: Int
    /// The security settings for SMTP communication.
    public let security: Security
    /// The timeout duration for SMTP operations.
    public let timeout: TimeAmount
    /// The hello method to use during SMTP communication.
    public let helloMethod: HelloMethod
    /// The sign-in method for authenticating with the SMTP server.
    public let signInMethod: SignInMethod

    /// Initializes SMTP configuration.
    /// - Parameters:
    ///   - hostname: The hostname of the SMTP server.
    ///   - port: The port number of the SMTP server. Default is 587.
    ///   - signInMethod: The sign-in method for authenticating with the SMTP server.
    ///   - security: The security settings for SMTP communication. Default is .startTLS.
    ///   - timeout: The timeout duration for SMTP operations. Default is 10 seconds.
    ///   - helloMethod: The hello method to use during SMTP communication. Default is .helo.
    public init(
        hostname: String,
        port: Int = 587,
        signInMethod: SignInMethod,
        security: Security = .startTLS,
        timeout: TimeAmount = .seconds(10),
        helloMethod: HelloMethod = .helo
    ) {
        self.hostname = hostname
        self.port = port
        self.security = security
        self.timeout = timeout
        self.helloMethod = helloMethod
        self.signInMethod = signInMethod
    }
}
