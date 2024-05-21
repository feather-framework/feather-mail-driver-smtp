//
//  InboundSMTPResponseDecoder.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO

/// A handler for decoding inbound SMTP responses.
final class InboundSMTPResponseDecoder: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer
    typealias InboundOut = Response

    /// Handles inbound data read from the channel.
    /// - Parameters:
    ///   - context: The channel handler context.
    ///   - data: The inbound data.
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var response = unwrapInboundIn(data)

        if let firstFourBytes = response.readString(length: 4),
            let code = Int(firstFourBytes.dropLast())
        {
            let remainder =
                response.readString(length: response.readableBytes) ?? ""

            let firstCharacter = firstFourBytes.first!
            let fourthCharacter = firstFourBytes.last!

            switch (firstCharacter, fourthCharacter) {
            case ("2", " "), ("3", " "):
                let parsedMessage = Response.ok(code, remainder)
                context.fireChannelRead(wrapInboundOut(parsedMessage))
            case (_, "-"):
                ()
            default:
                context.fireChannelRead(
                    wrapInboundOut(.error(firstFourBytes + remainder))
                )
            }
        }
        else {
            context.fireErrorCaught(NIOSMTPError.invalidMessage)
        }
    }
}
