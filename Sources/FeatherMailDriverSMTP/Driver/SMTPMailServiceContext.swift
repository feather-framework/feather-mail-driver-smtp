//
//  SMTPMailServiceContext.swift
//  FeatherMailDriverSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO
import NIOSMTP
import FeatherService

public struct SMTPMailServiceContext: ServiceContext {

    let eventLoopGroup: EventLoopGroup
    let smtpConfig: Configuration
    
    public init(
        eventLoopGroup: EventLoopGroup,
        smtpConfig: Configuration
    ) {
        self.eventLoopGroup = eventLoopGroup
        self.smtpConfig = smtpConfig
    }

    public func createDriver() throws -> ServiceDriver {
        SMTPMailServiceDriver()
    }
}
