//
//  NIOSMTP.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

https://feather-framework.github.io/feather-spec/
https://feather-framework.github.io/feather-spec/documentation/featherspec
import NIO
import Logging

/// Represents an SMTP client for sending emails asynchronously.
public struct NIOSMTP: Sendable {

    /// The event loop group used for asynchronous operations.
    public let eventLoopGroup: EventLoopGroup
    /// The SMTP configuration settings.
    public let config: Configuration
    /// An optional logger for logging events.
    public let logger: Logger?

    /// Initializes an NIOSMTP instance.
    ///
    /// - Parameters:
    ///   - eventLoopGroup: The event loop group to use for asynchronous operations.
    ///   - configuration: The SMTP configuration settings.
    ///   - logger: An optional logger for logging events.
    public init(
        eventLoopGroup: EventLoopGroup,
        configuration: Configuration,
        logger: Logger? = nil
    ) {
        self.eventLoopGroup = eventLoopGroup
        self.config = configuration
        self.logger = logger
    }

    /// Sends an email asynchronously.
    ///
    /// - Parameter email: The email message to be sent.
    /// - Throws: An error if the sending process encounters an issue.
    /// - Returns: An event loop future indicating completion of the sending process.
    public func send(_ email: Mail) async throws {
        let result = try await sendWithPromise(email: email).get()
        switch result {
        case .success(_):
            break
        case .failure(let error):
            throw error
        }
    }

    /// Sends an email message with a promise.
    ///
    /// - Parameter email: The email message to be sent.
    /// - Returns: An event loop future with a result indicating success or failure.
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
