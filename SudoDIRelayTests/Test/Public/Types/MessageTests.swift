//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import XCTest
@testable import SudoDIRelay

class MessageTests: XCTestCase {

    func test_RelayMessage_Equatable() {
        let first = Message(
            id: "message-id",
            createdAt: Date(millisecondsSince1970: 1.0),
            updatedAt: Date(millisecondsSince1970: 2.0),
            ownerId: "owner-id",
            sudoId: "sudo-id",
            postboxId: "postbox-id",
            message: "message contents"
        )
        let second = Message(
            id: "message-id",
            createdAt: Date(millisecondsSince1970: 1.0),
            updatedAt: Date(millisecondsSince1970: 2.0),
            ownerId: "owner-id",
            sudoId: "sudo-id",
            postboxId: "postbox-id",
            message: "message contents"
        )
        XCTAssertEqual(first, second)
    }

    func test_RelayMessage_CorrectValues() {
        let message = Message(
            id: "message-id",
            createdAt: Date(millisecondsSince1970: 1.0),
            updatedAt: Date(millisecondsSince1970: 2.0),
            ownerId: "owner-id",
            sudoId: "sudo-id",
            postboxId: "postbox-id",
            message: "message contents"
        )
        XCTAssertEqual(message.id, "message-id")
        XCTAssertEqual(message.createdAt, Date(millisecondsSince1970: 1.0))
        XCTAssertEqual(message.updatedAt, Date(millisecondsSince1970: 2.0))
        XCTAssertEqual(message.ownerId, "owner-id")
        XCTAssertEqual(message.sudoId, "sudo-id")
        XCTAssertEqual(message.postboxId, "postbox-id")
        XCTAssertEqual(message.message, "message contents")
    }
}
