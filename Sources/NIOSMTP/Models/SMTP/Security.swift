//
//  Security.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO
import NIOSSL

/// An enumeration representing security options for SMTP communication.
public enum Security: Sendable {

    /// Communication without any encryption (even password is send as a plain text).
    case none

    /// The connection should use SSL or TLS encryption immediately.
    case ssl

    /// Elevates the connection to use TLS encryption immediately after
    /// reading the greeting and capabilities of the server. If the server
    /// does not support the STARTTLS extension, then the connection will
    /// fail and error will be thrown.
    case startTLS

    /// Elevates the connection to use TLS encryption immediately after
    /// reading the greeting and capabilities of the server, but only if
    /// the server supports the STARTTLS extension.
    case startTLSIfAvailable
}

extension Security {

    /// Checks if StartTLS is enabled.
    var isStartTLSEnabled: Bool {
        self == .startTLS || self == .startTLSIfAvailable
    }

    /// Configures the channel for the specified security option.
    /// - Parameters:
    ///   - channel: The channel to configure.
    ///   - hostname: The hostname of the server.
    /// - Returns: An event loop future indicating the success of the configuration.
    func configureChannel(
        on channel: Channel,
        hostname: String
    ) -> EventLoopFuture<Void> {
        switch self {
        case .ssl:
            do {
                let sslContext = try NIOSSLContext(
                    configuration: .makeClientConfiguration()
                )
                let sslHandler = try NIOSSLClientHandler(
                    context: sslContext,
                    serverHostname: hostname
                )
                return channel.pipeline.addHandler(sslHandler)
            }
            catch {
                return channel.eventLoop.makeSucceededFuture(())
            }
        default:
            return channel.eventLoop.makeSucceededFuture(())
        }
    }
}
