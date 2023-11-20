//
//  Body.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 20/11/2023.
//

public enum Body: Sendable {
    case plainText(String)
    case html(String)
}
