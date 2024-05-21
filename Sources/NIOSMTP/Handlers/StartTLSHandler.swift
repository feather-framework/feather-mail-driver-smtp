//
//  StartTLSHandler.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO
import NIOSSL

/// A handler responsible for initiating the StartTLS process.
final class StartTLSHandler: ChannelDuplexHandler, RemovableChannelHandler {
    typealias InboundIn = Response
    typealias InboundOut = Response
    typealias OutboundIn = Request
    typealias OutboundOut = Request

    private let config: Configuration
    private let allDonePromise: EventLoopPromise<Void>
    private var waitingForStartTlsResponse = false

    /// Initializes the StartTLS handler.
    /// - Parameters:
    ///   - configuration: The SMTP configuration.
    ///   - promise: The promise to complete when the StartTLS process finishes.
    init(
        configuration: Configuration,
        promise: EventLoopPromise<Void>
    ) {
        config = configuration
        allDonePromise = promise
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        guard config.security.isStartTLSEnabled else {
            return context.fireChannelRead(data)
        }

        if waitingForStartTlsResponse {
            waitingForStartTlsResponse = false

            let result = unwrapInboundIn(data)
            switch result {
            case .error(let message):
                if config.security == .startTLS {
                    return allDonePromise.fail(NIOSMTPError.custom(message))
                }
                let startTlsResult = wrapInboundOut(
                    .ok(200, "STARTTLS is not supported")
                )
                return context.fireChannelRead(startTlsResult)
            case .ok:
                initializeTlsHandler(context: context, data: data)
            }
        }
        else {
            context.fireChannelRead(data)
        }
    }

    func write(
        context: ChannelHandlerContext,
        data: NIOAny,
        promise: EventLoopPromise<Void>?
    ) {
        guard config.security.isStartTLSEnabled else {
            return context.write(data, promise: promise)
        }

        let command = unwrapOutboundIn(data)
        switch command {
        case .startTLS:
            waitingForStartTlsResponse = true
        default:
            break
        }

        context.write(data, promise: promise)
    }

    private func initializeTlsHandler(
        context: ChannelHandlerContext,
        data: NIOAny
    ) {
        do {
            let sslContext = try NIOSSLContext(
                configuration: .makeClientConfiguration()
            )
            let sslHandler = try NIOSSLClientHandler(
                context: sslContext,
                serverHostname: config.hostname
            )
            _ = context.channel.pipeline.addHandler(
                sslHandler,
                name: "NIOSSLClientHandler",
                position: .first
            )

            context.fireChannelRead(data)
            _ = context.channel.pipeline.removeHandler(self)
        }
        catch let error {
            allDonePromise.fail(error)
        }
    }
}
