//
//  SMTPMailComponentBuilder.swift
//  FeatherMailDriverSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import FeatherComponent
import NIOSMTP

/// A factory for creating SMTP mail components.
struct SMTPMailComponentFactory: ComponentFactory {

    /// Builds an SMTP mail component using the provided configuration.
    /// - Parameter config: The component configuration.
    /// - Throws: An error if the component cannot be built.
    /// - Returns: An SMTP mail component.
    func build(using config: ComponentConfig) throws -> Component {
        SMTPMailComponent(config: config)
    }
}
