//
//  SMTPMailComponentBuilder.swift
//  FeatherMailDriverSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import FeatherComponent
import NIOSMTP

struct SMTPMailComponentFactory: ComponentFactory {

    func build(using config: ComponentConfig) throws -> Component {
        SMTPMailComponent(config: config)
    }
}
