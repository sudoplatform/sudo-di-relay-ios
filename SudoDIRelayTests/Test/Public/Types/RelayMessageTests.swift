//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import XCTest
@testable import SudoDIRelay

class RelayMessageTests: XCTestCase {

    func test_RelayMessage_Direction_Equitable() {
        let first = RelayMessage.Direction.inbound
        let second = RelayMessage.Direction.inbound
        let third = RelayMessage.Direction.outbound

        XCTAssertEqual(first, second)
        XCTAssertNotEqual(first, third)
    }

    func test_RelayMessage_Equitable() {
        let first = RelayMessage(
            messageId: "dummyId",
            connectionId: "dummyId",
            cipherText: "",
            direction: RelayMessage.Direction.inbound,
            timestamp: Date(millisecondsSince1970: 0)
        )
        let second = RelayMessage(
            messageId: "dummyId",
            connectionId: "dummyId",
            cipherText: "",
            direction: RelayMessage.Direction.inbound,
            timestamp: Date(millisecondsSince1970: 0)
        )
        XCTAssertEqual(first, second)
    }

    func test_RelayMessage_CorrectValues() {
        let message = RelayMessage(
            messageId: "dummyId",
            connectionId: "dummyId",
            cipherText: "",
            direction: RelayMessage.Direction.inbound,
            timestamp: Date(millisecondsSince1970: 0)
        )
        XCTAssertEqual(message.messageId, "dummyId")
        XCTAssertEqual(message.connectionId, "dummyId")
        XCTAssertEqual(message.cipherText, "")
        XCTAssertEqual(message.direction, RelayMessage.Direction.inbound)
        XCTAssertEqual(message.timestamp, Date(millisecondsSince1970: 0))
    }
}
