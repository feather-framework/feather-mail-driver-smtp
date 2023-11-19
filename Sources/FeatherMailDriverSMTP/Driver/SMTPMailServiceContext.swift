//
//  SMTPMailServiceContext.swift
//  FeatherMailDriverSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO
import NIOSMTP
import FeatherService

struct SMTPMailServiceContext: ServiceContext {

    let eventLoopGroup: EventLoopGroup

    let smtpConfig: Configuration

    func createDriver() throws -> ServiceDriver {
        SMTPMailServiceDriver()
    }

}
