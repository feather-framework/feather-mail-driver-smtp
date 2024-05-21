//
//  SMTPMailComponentContext.swift
//  FeatherMailDriverSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO
import NIOSMTP
import FeatherComponent

/// A structure representing the context for the SMTP mail component.
public struct SMTPMailComponentContext: ComponentContext {

    /// The event loop group.
    let eventLoopGroup: EventLoopGroup
    /// The SMTP configuration.
    let smtpConfig: Configuration

    /// Initializes the SMTP mail component context.
    /// - Parameters:
    ///   - eventLoopGroup: The event loop group.
    ///   - smtpConfig: The SMTP configuration.
    public init(
        eventLoopGroup: EventLoopGroup,
        smtpConfig: Configuration
    ) {
        self.eventLoopGroup = eventLoopGroup
        self.smtpConfig = smtpConfig
    }

    /// Creates a component factory.
    /// - Throws: An error if the component factory cannot be created.
    /// - Returns: A component factory.
    public func make() throws -> ComponentFactory {
        SMTPMailComponentFactory()
    }
}
