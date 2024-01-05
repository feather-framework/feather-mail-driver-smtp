//
//  SMTPMailServiceBuilder.swift
//  FeatherMailDriverSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import FeatherService
import NIOSMTP

struct SMTPMailServiceBuilder: ServiceBuilder {

    func build(using config: ServiceConfig) throws -> Service {
        SMTPMailService(config: config)
    }
}
