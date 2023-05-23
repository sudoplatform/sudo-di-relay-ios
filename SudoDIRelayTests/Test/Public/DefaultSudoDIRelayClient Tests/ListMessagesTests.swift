//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DefaultSudoDIRelayClientListMessages: DefaultSudoDIRelayTestCase {

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }

    // MARK: - Properties

    let now = Date.now

    // MARK: - Tests: ListMessages

    func test_listMessages_RespectsFailure() async {
        mockRelayService.listMessagesError = SudoDIRelayError.unauthorizedPostboxAccess
        do {
            try _ = await instanceUnderTest.listMessages(limit: nil, nextToken: nil)
            XCTFail("Unexpected success.")
        } catch {
            XCTAssertEqual(mockRelayService.listMessagesLastProperties?.0, nil)
            XCTAssertEqual(mockRelayService.listMessagesLastProperties?.1, nil)
            XCTAssertErrorsEqual(error, SudoDIRelayError.unauthorizedPostboxAccess)
        }
    }

    func test_listMessages_SuccessResult() async {

        let expected = ListOutput<Message>(
            items: [Message(
                id: "message-id",
                createdAt: now,
                updatedAt: now,
                ownerId: "owner-id",
                sudoId: "sudo-id",
                postboxId: "postbox-id",
                message: "message-contents"
            )], nextToken: nil)
        mockRelayService.listMessagesResult = expected

        do {
            let created = try await instanceUnderTest.listMessages( limit: 4, nextToken: "next-token")
            XCTAssertEqual(created, expected)
            XCTAssertEqual(mockRelayService.listMessagesLastProperties?.0, 4)
            XCTAssertEqual(mockRelayService.listMessagesLastProperties?.1, "next-token")
        } catch {
            XCTFail("Unexpected error: \(error)")

        }
    }
}
