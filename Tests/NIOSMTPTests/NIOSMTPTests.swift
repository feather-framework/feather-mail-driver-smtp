import XCTest
import NIO
import NIOSMTP
import Logging

final class NIOSMTPTests: XCTestCase {

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

    private func send(_ email: Mail) async throws {

        let eventLoopGroup = MultiThreadedEventLoopGroup(
            numberOfThreads: 1
        )
        let smtp = NIOSMTP(
            eventLoopGroup: eventLoopGroup,
            configuration: .init(
                hostname: host,
                signInMethod: .credentials(
                    username: user,
                    password: pass
                )
            ),
            logger: .init(label: "nio-smtp")
        )
        try await smtp.send(email)

        try await eventLoopGroup.shutdownGracefully()
    }

    // MARK: - test cases

    func testPlainText() async throws {
        let email = try Mail(
            from: .init(from),
            to: [
                .init(to)
            ],
            subject: "Test plain text email",
            body: "This is a plain text email."
        )
        try await send(email)
    }

    func testHMTL() async throws {
        let email = try Mail(
            from: .init(from),
            to: [
                .init(to)
            ],
            subject: "Test HTML email",
            body: "This is a <b>HTML</b> email.",
            isHtml: true
        )
        try await send(email)
    }

    func testAttachment() async throws {
        let png =
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
        let data = try Data(png.base64Decoded())

        let email = try Mail(
            from: .init(from),
            to: [
                .init(to)
            ],
            subject: "Test with attachment",
            body: "This is an email with a very small attachment.",
            attachments: [
                .init(
                    name: "test.png",
                    contentType: "image/png",
                    data: data
                )
            ]
        )
        try await send(email)
    }
}
