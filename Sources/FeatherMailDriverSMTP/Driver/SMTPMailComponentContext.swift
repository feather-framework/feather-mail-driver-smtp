//
//  SMTPMailComponentContext.swift
//  FeatherMailDriverSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO
import NIOSMTP
import FeatherComponent

public struct SMTPMailComponentContext: ComponentContext {

    let eventLoopGroup: EventLoopGroup
    let smtpConfig: Configuration
    
    public init(
        eventLoopGroup: EventLoopGroup,
        smtpConfig: Configuration
    ) {
        self.eventLoopGroup = eventLoopGroup
        self.smtpConfig = smtpConfig
    }

    public func make() throws -> ComponentBuilder {
        SMTPMailComponentBuilder()
    }
}
