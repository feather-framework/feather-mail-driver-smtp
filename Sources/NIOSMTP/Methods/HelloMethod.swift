//
//  HelloMethod.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

/// An enumeration representing hello methods for SMTP communication.
public enum HelloMethod: String, Sendable {
    /// The HELO method.
    case helo = "HELO"
    /// The EHLO method.
    case ehlo = "EHLO"
}
