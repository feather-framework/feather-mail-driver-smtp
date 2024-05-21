//
//  File.swift
//
//
//  Created by Tibor Bodecs on 20/11/2023.
//

import Foundation
import NIOCore

extension Mail {
    /// Generates a boundary string for multipart messages.
    private func createBoundary() -> String {
        UUID().uuidString
            .replacingOccurrences(of: "-", with: "")
            .lowercased()
    }

    /// Writes the SMTP message to the given buffer.
    ///
    /// - Parameters:
    ///   - buffer: The buffer to write the message to.
    func writeSMTPMessageToBuffer(
        _ buffer: inout ByteBuffer
    ) {
        let date = Date()
        let time = date.timeIntervalSince1970

        // NOTE: this is very inefficient
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        let dateString = dateFormatter.string(from: date)

        let uuid = "<\(time)\(from.address.drop { $0 != "@" })>"
        buffer.writeString("From: \(from.mime)\r\n")
        let toAddresses = to.map(\.mime).joined(separator: ", ")
        buffer.writeString("To: \(toAddresses)\r\n")
        let ccAddresses = cc.map(\.mime).joined(separator: ", ")
        buffer.writeString("Cc: \(ccAddresses)\r\n")
        let replyToAddresses = replyTo.map(\.mime).joined(separator: ", ")
        buffer.writeString("Reply-to: \(replyToAddresses)\r\n")
        buffer.writeString("Subject: \(subject)\r\n")
        buffer.writeString("Date: \(dateString)\r\n")
        buffer.writeString("Message-ID: \(uuid)\r\n")
        if let reference = reference {
            buffer.writeString("In-Reply-To: \(reference)\r\n")
            buffer.writeString("References: \(reference)\r\n")
        }

        let boundary = createBoundary()
        if !attachments.isEmpty {
            buffer.writeString(
                "Content-type: multipart/mixed; boundary=\"\(boundary)\"\r\n"
            )
            buffer.writeString("Mime-Version: 1.0\r\n\r\n")
        }

        switch body {
        case .plainText(let value):
            if !attachments.isEmpty {
                buffer.writeString("--\(boundary)\r\n")
            }
            buffer.writeString(
                "Content-Type: text/plain; charset=\"UTF-8\"\r\n"
            )
            buffer.writeString("Mime-Version: 1.0\r\n\r\n")
            buffer.writeString("\(value)\r\n\r\n")
        case .html(let value):
            if !attachments.isEmpty {
                buffer.writeString("--\(boundary)\r\n")
            }
            buffer.writeString("Content-Type: text/html; charset=\"UTF-8\"\r\n")
            buffer.writeString("Mime-Version: 1.0\r\n\r\n")
            buffer.writeString("\(value)\r\n")
        }

        for attachment in attachments {
            buffer.writeString("--\(boundary)\r\n")
            buffer.writeString("Content-type: \(attachment.contentType)\r\n")
            buffer.writeString("Content-Transfer-Encoding: base64\r\n")
            buffer.writeString(
                "Content-Disposition: attachment; filename=\"\(attachment.name)\"\r\n\r\n"
            )
            buffer.writeString("\(attachment.data.base64EncodedString())\r\n")
        }

        buffer.writeString("\r\n.")
    }
}
