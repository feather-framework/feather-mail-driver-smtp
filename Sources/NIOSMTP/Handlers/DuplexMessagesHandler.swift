//
//  DuplexMessagesHandler.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation
import NIO
import Logging

/// Logs inbound and outbound messages.
final class DuplexMessagesHandler: ChannelDuplexHandler {

    typealias InboundIn = ByteBuffer
    typealias InboundOut = ByteBuffer
    typealias OutboundIn = ByteBuffer
    typealias OutboundOut = ByteBuffer

    let logger: Logger?

    /// Initializes the duplex message handler.
    ///
    /// - Parameter logger: Optional logger for message logging.
    init(logger: Logger? = nil) {
        self.logger = logger
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        if let logger = logger {
            let buffer = unwrapInboundIn(data)
            let message = String(
                decoding: buffer.readableBytesView,
                as: UTF8.self
            )
            .trimmingCharacters(in: .whitespacesAndNewlines)
            logger.trace("==> \(message)")
        }
        context.fireChannelRead(data)
    }

    func write(
        context: ChannelHandlerContext,
        data: NIOAny,
        promise: EventLoopPromise<Void>?
    ) {
        if let logger = logger {
            let buffer = unwrapOutboundIn(data)
            let message = String(
                decoding: buffer.readableBytesView,
                as: UTF8.self
            )
            .trimmingCharacters(in: .whitespacesAndNewlines)
            logger.trace("==> \(message)")
        }
        context.write(data, promise: promise)
    }

}
