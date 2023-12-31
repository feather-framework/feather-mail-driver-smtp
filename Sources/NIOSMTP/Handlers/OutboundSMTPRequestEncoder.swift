//
//  OutboundSMTPRequestEncoder.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation
import NIO

final class OutboundSMTPRequestEncoder: MessageToByteEncoder {
    typealias OutboundIn = Request

    func encode(data: Request, out: inout ByteBuffer) {
        switch data {
        case .sayHello(serverName: let server, let helloMethod):
            out.writeString("\(helloMethod.rawValue) \(server)")
        case .startTLS:
            out.writeString("STARTTLS")
        case .sayHelloAfterTLS(serverName: let server, let helloMethod):
            out.writeString("\(helloMethod.rawValue) \(server)")
        case .mailFrom(let from):
            out.writeString("MAIL FROM:<\(from)>")
        case .recipient(let rcpt):
            out.writeString("RCPT TO:<\(rcpt)>")
        case .data:
            out.writeString("DATA")
        case .transferData(let email):
            email.writeSMTPMessageToBuffer(&out)
        case .quit:
            out.writeString("QUIT")
        case .beginAuthentication:
            out.writeString("AUTH LOGIN")
        case .authUser(let user):
            let userData = Data(user.utf8)
            out.writeBytes(userData.base64EncodedData())
        case .authPassword(let password):
            let passwordData = Data(password.utf8)
            out.writeBytes(passwordData.base64EncodedData())
        }
        out.writeString("\r\n")
    }
}
