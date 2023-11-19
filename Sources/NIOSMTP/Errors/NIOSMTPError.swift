//
//  NIOSMTPError.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

enum NIOSMTPError: Error {
    case invalidRecipient
    case invalidMessage
    case custom(String)
    case unknown(Error)
}
