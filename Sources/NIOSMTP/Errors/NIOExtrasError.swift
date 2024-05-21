//
//  NIOExtrasError.swift
//  NIOSMTP
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIOCore

/// Protocol representing errors in NIOExtras.
protocol NIOExtrasError: Equatable, Error {}

/// Namespace for errors in NIOExtras.
enum NIOExtrasErrors {

    /// Error type representing leftover bytes in a buffer.
    struct LeftOverBytesError: NIOExtrasError {
        /// The leftover bytes in the buffer.
        let leftOverBytes: ByteBuffer
    }
}
