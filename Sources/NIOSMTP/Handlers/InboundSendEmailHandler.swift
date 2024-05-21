//
//  InboundSendEmailHandler.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO
import NIOSSL

/// A handler for processing inbound SMTP responses during email sending.
final class InboundSendEmailHandler: ChannelInboundHandler {
    typealias InboundIn = Response
    typealias OutboundOut = Request

    /// Enumeration representing the expected response states.
    enum Expect {
        case initialMessageFromServer
        case okAfterHello
        case okAfterStartTls
        case okAfterStartTlsHello
        case okAfterAuthBegin
        case okAfterUsername
        case okAfterPassword
        case okAfterMailFrom
        case okAfterRecipient
        case okAfterDataCommand
        case okAfterMailData
        case okAfterQuit
        case nothing
        case error
    }

    private var currentlyWaitingFor = Expect.initialMessageFromServer
    private let email: Mail
    private let config: Configuration
    private let promise: EventLoopPromise<Void>
    private var recipients: [Address] = []

    /// Initializes the inbound send email handler.
    /// - Parameters:
    ///   - config: The SMTP configuration.
    ///   - email: The email message to send.
    ///   - promise: The promise to complete when the email sending process finishes.
    init(
        config: Configuration,
        email: Mail,
        promise: EventLoopPromise<Void>
    ) {
        self.config = config
        self.email = email
        self.promise = promise
        self.recipients += email.to
        self.recipients += email.cc
        self.recipients += email.bcc
    }

    /// Sends a command to the SMTP server.
    /// - Parameters:
    ///   - context: The channel handler context.
    ///   - command: The command to send.
    func send(context: ChannelHandlerContext, command: Request) {
        context.writeAndFlush(wrapOutboundOut(command))
            .cascadeFailure(to: promise)
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let result = unwrapInboundIn(data)
        switch result {
        case .error(let message):
            promise.fail(NIOSMTPError.custom(message))
            return
        case .ok:
            ()
        }

        switch currentlyWaitingFor {
        case .initialMessageFromServer:
            send(
                context: context,
                command: .sayHello(
                    serverName: config.hostname,
                    helloMethod: config.helloMethod
                )
            )
            currentlyWaitingFor = .okAfterHello
        case .okAfterHello:
            if config.security.isStartTLSEnabled {
                send(context: context, command: .startTLS)
                currentlyWaitingFor = .okAfterStartTls
            }
            else {
                switch config.signInMethod {
                case .credentials(_, _):
                    send(context: context, command: .beginAuthentication)
                    currentlyWaitingFor = .okAfterAuthBegin
                case .anonymous:
                    send(
                        context: context,
                        command: .mailFrom(email.from.address)
                    )
                    currentlyWaitingFor = .okAfterMailFrom
                }
            }
        case .okAfterStartTls:
            send(
                context: context,
                command: .sayHelloAfterTLS(
                    serverName: config.hostname,
                    helloMethod: config.helloMethod
                )
            )
            currentlyWaitingFor = .okAfterStartTlsHello
        case .okAfterStartTlsHello:
            send(context: context, command: .beginAuthentication)
            currentlyWaitingFor = .okAfterAuthBegin
        case .okAfterAuthBegin:
            switch config.signInMethod {
            case .credentials(let username, _):
                send(context: context, command: .authUser(username))
                currentlyWaitingFor = .okAfterUsername
            case .anonymous:
                promise.fail(
                    NIOSMTPError.custom(
                        "After auth begin executed for anonymous sign in method"
                    )
                )
            }
        case .okAfterUsername:
            switch config.signInMethod {
            case .credentials(_, let password):
                send(context: context, command: .authPassword(password))
                currentlyWaitingFor = .okAfterPassword
            case .anonymous:
                promise.fail(
                    NIOSMTPError.custom(
                        "After user name executed for anonymous sign in method"
                    )
                )
            }
        case .okAfterPassword:
            send(
                context: context,
                command: .mailFrom(email.from.address)
            )
            currentlyWaitingFor = .okAfterMailFrom
        case .okAfterMailFrom:
            if let recipient = recipients.popLast() {
                send(
                    context: context,
                    command: .recipient(recipient.address)
                )
            }
            else {
                fallthrough
            }
        case .okAfterRecipient:
            send(context: context, command: .data)
            currentlyWaitingFor = .okAfterDataCommand
        case .okAfterDataCommand:
            send(context: context, command: .transferData(email))
            currentlyWaitingFor = .okAfterMailData
        case .okAfterMailData:
            send(context: context, command: .quit)
            currentlyWaitingFor = .okAfterQuit
        case .okAfterQuit:
            promise.succeed(())
            currentlyWaitingFor = .nothing
        case .nothing:
            ()
        case .error:
            promise.fail(
                NIOSMTPError.custom(
                    "Communication error state"
                )
            )
        }
    }
}
