//
//  SMTPMailComponentContext.swift
//  FeatherMailDriverSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO
import NIOSMTP
import FeatherComponent

/// smtp mail component context
public struct SMTPMailComponentContext: ComponentContext {

    let eventLoopGroup: EventLoopGroup
    let smtpConfig: Configuration

    /// smtp mail component context init
    public init(
        eventLoopGroup: EventLoopGroup,
        smtpConfig: Configuration
    ) {
        self.eventLoopGroup = eventLoopGroup
        self.smtpConfig = smtpConfig
    }

    /// make a new component factory
    public func make() throws -> ComponentFactory {
        SMTPMailComponentFactory()
    }
}
