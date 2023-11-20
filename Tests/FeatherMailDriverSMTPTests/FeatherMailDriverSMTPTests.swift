//
//  FeatherMailDriverSMTPTests.swift
//  FeatherMailDriverSMTPTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import NIO
import Logging
import Foundation
import XCTest
import FeatherService
import FeatherMail
import FeatherMailDriverSMTP
import XCTFeatherMail

final class FeatherMailDriverSMTPTests: XCTestCase {

    var host: String {
        ProcessInfo.processInfo.environment["SMTP_HOST"]!
    }

    var user: String {
        ProcessInfo.processInfo.environment["SMTP_USER"]!
    }

    var pass: String {
        ProcessInfo.processInfo.environment["SMTP_PASS"]!
    }

    var from: String {
        ProcessInfo.processInfo.environment["MAIL_FROM"]!
    }

    var to: String {
        ProcessInfo.processInfo.environment["MAIL_TO"]!
    }

    func testSMTPDriverUsingTestSuite() async throws {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

        do {
            let registry = ServiceRegistry()
            try await registry.add(
                SMTPMailServiceContext(
                    eventLoopGroup: eventLoopGroup,
                    smtpConfig: .init(
                        hostname: self.host,
                        signInMethod: .credentials(
                            username: self.user,
                            password: self.pass
                        )
                    )
                )
            )

            try await registry.run()
            let mail = try await registry.mail()

            do {
                let suite = MailTestSuite(mail)
                try await suite.testAll(from: from, to: to)
                try await registry.shutdown()
            }
            catch {
                try await registry.shutdown()
                throw error
            }
        }
        catch {
            XCTFail("\(error)")
        }

        try await eventLoopGroup.shutdownGracefully()
    }

}
