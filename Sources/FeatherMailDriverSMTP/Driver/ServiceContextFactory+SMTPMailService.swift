//
//  ServiceContextFactory+SMTPMailService.swift
//  FeatherMailDriverSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO
import FeatherService
import NIOSMTP

public extension ServiceContextFactory {

    static func smtpMail(
        eventLoopGroup: EventLoopGroup,
        smtpConfig: Configuration
    ) -> Self {
        .init {
            SMTPMailServiceContext(
                eventLoopGroup: eventLoopGroup,
                smtpConfig: smtpConfig
            )
        }
    }
}
