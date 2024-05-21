//
//  Response.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

/// An enumeration representing SMTP responses.
public enum Response {
    /// Success response with status code and message.
    case ok(Int, String)
    /// Error response with message.
    case error(String)
}
