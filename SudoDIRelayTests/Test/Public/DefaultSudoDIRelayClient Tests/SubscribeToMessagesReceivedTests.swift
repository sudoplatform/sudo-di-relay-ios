//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DefaultSudoDIRelayClientSubscribeToMessagesReceived: DefaultSudoDIRelayTestCase {

    // MARK: - Properties

    let now = Date.now
    // MARK: - Tests

    func test_subscribeToMessageCreated_RespectsFailure() async {
        mockRelayService.subscribeToMessageCreatedResult = .failure(AnyError("Failure from subscription"))
        do {
            try _ = await instanceUnderTest.subscribeToMessageCreated(
                statusChangeHandler: { _ in },
                resultHandler: {
                    result in
                        switch result {
                        case let .failure(error as AnyError):
                            XCTAssertEqual(error, AnyError("Failure from subscription"))
                        default:
                            XCTFail("Unexpected result: \(result)")
                        }
                    })
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_subscribeToMessageCreated_ReturnsSuccessResult() async {
        let expected = Message(
            id: "message-id",
            createdAt: now,
            updatedAt: now,
            ownerId: "owner-id",
            sudoId: "sudo-id",
            postboxId: "postbox-id",
            message: "message-contents"
        )
        mockRelayService.subscribeToMessageCreatedResult = .success(expected)
        do {
            _ = try await self.instanceUnderTest.subscribeToMessageCreated(
                statusChangeHandler: { _ in },
                resultHandler: { result in
                    switch result {
                    case let .success(message):
                        XCTAssertEqual(message, expected)
                    default:
                        XCTFail("Unexpected result: \(result)")
                    }
                })
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
//    func test_subscribeToMessageCreated_SuccessResult() async {
//        let expected = Postbox(
//            id: "postbox-id",
//            createdAt: now,
//            updatedAt: now,
//            ownerId: "owner-id",
//            sudoId: "sudo-id",
//            connectionId: "my-connection-id",
//            isEnabled: true,
//            serviceEndpoint: "https://service-endpoint.com")
//        mockRelayService.subscribeToMessageCreatedResult = expected
//
//        do {
//            let created = try await instanceUnderTest.subscribeToMessageCreated(
//                withConnectionId: "my-connection-id",
//                ownershipProofToken: "dummyProof",
//                isEnabled: true)
//            XCTAssertEqual(created, expected)
//            XCTAssertEqual(mockRelayService.subscribeToMessageCreatedLastProperties?.0, "my-connection-id")
//            XCTAssertEqual(mockRelayService.subscribeToMessageCreatedLastProperties?.1, "dummyProof")
//            XCTAssertEqual(mockRelayService.subscribeToMessageCreatedLastProperties?.2, true)
//        } catch {
//            XCTFail("Unexpected error: \(error)")
//
//        }
//    }
}
