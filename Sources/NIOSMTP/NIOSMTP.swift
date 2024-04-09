//
//  NIOSMTP.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO
import Logging

/// Send an Email with an SMTP provider
public struct NIOSMTP: Sendable {

    /// event llop group
    public let eventLoopGroup: EventLoopGroup
    /// config
    public let config: Configuration
    /// logger
    public let logger: Logger?

    /// nio smtp init function
    public init(
        eventLoopGroup: EventLoopGroup,
        configuration: Configuration,
        logger: Logger? = nil
    ) {
        self.eventLoopGroup = eventLoopGroup
        self.config = configuration
        self.logger = logger
    }

    ///
    /// Send an Email with SMTP sender
    ///
    /// - Parameter email: Email struct to send
    /// - Throws: Sending errors
    public func send(_ email: Mail) async throws {
        let result = try await sendWithPromise(email: email).get()
        switch result {
        case .success(_):
            break
        case .failure(let error):
            throw error
        }
    }

    private func sendWithPromise(
        email: Mail
    ) throws -> EventLoopFuture<Result<Bool, Error>> {
        let eventLoop = eventLoopGroup.next()
        let promise: EventLoopPromise<Void> = eventLoop.makePromise()
        let bootstrap = ClientBootstrap(group: eventLoop)
            .connectTimeout(config.timeout)
            .channelOption(
                ChannelOptions.socket(
                    SocketOptionLevel(SOL_SOCKET),
                    SO_REUSEADDR
                ),
                value: 1
            )
            .channelInitializer { channel in
                let secureChannelFuture = config.security.configureChannel(
                    on: channel,
                    hostname: config.hostname
                )
                return secureChannelFuture.flatMap {
                    let defaultHandlers: [ChannelHandler] = [
                        DuplexMessagesHandler(logger: logger),
                        ByteToMessageHandler(InboundLineBasedFrameDecoder()),
                        InboundSMTPResponseDecoder(),
                        MessageToByteHandler(OutboundSMTPRequestEncoder()),
                        StartTLSHandler(
                            configuration: config,
                            promise: promise
                        ),
                        InboundSendEmailHandler(
                            config: config,
                            email: email,
                            promise: promise
                        ),
                    ]
                    return channel.pipeline.addHandlers(
                        defaultHandlers,
                        position: .last
                    )
                }
            }

        let connection = bootstrap.connect(
            host: config.hostname,
            port: config.port
        )
        connection.cascadeFailure(to: promise)

        return promise.futureResult
            .map { () -> Result<Bool, Error> in
                connection.whenSuccess { $0.close(promise: nil) }
                return .success(true)
            }
            .flatMapError { error -> EventLoopFuture<Result<Bool, Error>> in
                return eventLoop.makeSucceededFuture(.failure(error))
            }
    }

}
