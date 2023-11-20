//
//  SMTPMailService.swift
//  FeatherMailDriverSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation
import FeatherService
import FeatherMail
import NIO
import NIOSMTP

@dynamicMemberLookup
struct SMTPMailService {

    let config: ServiceConfig

    subscript<T>(
        dynamicMember keyPath: KeyPath<SMTPMailServiceContext, T>
    ) -> T {
        let context = config.context as! SMTPMailServiceContext
        return context[keyPath: keyPath]
    }

    init(config: ServiceConfig) {
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

extension SMTPMailService: MailService {

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
