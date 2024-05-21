//
//  Request.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

/// An enumeration representing SMTP requests.
public enum Request {
    /// Request to say hello to the server.
    case sayHello(serverName: String, helloMethod: HelloMethod)
    /// Request to start TLS.
    case startTLS
    /// Request to say hello after TLS.
    case sayHelloAfterTLS(serverName: String, helloMethod: HelloMethod)
    /// Request to begin authentication.
    case beginAuthentication
    /// Request to authenticate a user.
    case authUser(String)
    /// Request to authenticate a password.
    case authPassword(String)
    /// Request to specify the sender's email address.
    case mailFrom(String)
    /// Request to specify a recipient's email address.
    case recipient(String)
    /// Request to start the data transfer phase.
    case data
    /// Request to transfer email data.
    case transferData(Mail)
    /// Request to quit the SMTP session.
    case quit
}
