//
//  SMTPMailComponent.swift
//  FeatherMailDriverSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation
import FeatherComponent
import FeatherMail
import NIO
import NIOSMTP

@dynamicMemberLookup
struct SMTPMailComponent {

    let config: ComponentConfig

    subscript<T>(
        dynamicMember keyPath: KeyPath<SMTPMailComponentContext, T>
    ) -> T {
        let context = config.context as! SMTPMailComponentContext
        return context[keyPath: keyPath]
    }

    init(config: ComponentConfig) {
        self.config = config
    }
}

extension FeatherMail.Mail.Body {

    var toNIOSMTPBody: Body {
        switch self {
        case .plainText(let value):
            return .plainText(value)
        case .html(let value):
            return .html(value)
        }
    }
}

extension SMTPMailComponent: MailComponent {

    public func send(_ email: FeatherMail.Mail) async throws {

        let smtpMail = try Mail(
            from: Address(email.from.email, name: email.from.name),
            to: email.to.map {
                Address($0.email, name: $0.name)
            },
            cc: email.cc.map {
                Address($0.email, name: $0.name)
            },
            bcc: email.bcc.map {
                Address($0.email, name: $0.name)
            },
            replyTo: email.replyTo.map {
                Address($0.email, name: $0.name)
            },
            subject: email.subject,
            body: email.body.toNIOSMTPBody,
            reference: email.reference,
            attachments: email.attachments.map {
                Attachment(
                    name: $0.name,
                    contentType: $0.contentType,
                    data: $0.data
                )
            }
        )

        let smtp = NIOSMTP(
            eventLoopGroup: self.eventLoopGroup,
            configuration: self.smtpConfig,
            logger: logger
        )
        try await smtp.send(smtpMail)
    }
}
