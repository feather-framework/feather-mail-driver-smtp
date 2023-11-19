//
//  SMTPMailServiceDriver.swift
//  FeatherMailDriverSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import FeatherService
import NIOSMTP

struct SMTPMailServiceDriver: ServiceDriver {

    func run(using config: ServiceConfig) throws -> Service {
        SMTPMailService(config: config)
    }
}
