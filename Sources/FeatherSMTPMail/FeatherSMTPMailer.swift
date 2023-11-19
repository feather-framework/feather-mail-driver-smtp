import NIOSMTP
import NIOCore
import Logging
import FeatherMail

public struct FeatherSMTPMailer: FeatherMailer {
    let smtp: NIOSMTP
    let logger: Logger
    let eventLoop: EventLoop

    public init(smtp: NIOSMTP, logger: Logger, eventLoop: EventLoop) {
        self.smtp = smtp
        self.logger = logger
        self.eventLoop = eventLoop
    }

}
