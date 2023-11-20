//
//  Configuration.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO

/// Configuration for a SMTP provider
public struct Configuration: Sendable {
    public let hostname: String
    public let port: Int
    public let security: Security
    public let timeout: TimeAmount
    public let helloMethod: HelloMethod
    public let signInMethod: SignInMethod

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
