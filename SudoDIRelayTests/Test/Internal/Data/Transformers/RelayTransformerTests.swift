//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class RelayTransformerTests: XCTestCase {

    // MARK: - Properties

    let utcTimestamp: Double = 0.0

    // MARK: - Tests: GetMessages Transformers

    func test_transform_GetMessagesQuery_success() throws {
        let data = GetMessagesQuery.Data.GetMessage(
            messageId: "dummyId",
            connectionId: "dummyId",
            cipherText: "message",
            direction: Direction.inbound,
            utcTimestamp: utcTimestamp
        )
        let result = try RelayTransformer.transform([data])
        XCTAssertEqual(result[0].messageId, "dummyId")
        XCTAssertEqual(result[0].connectionId, "dummyId")
        XCTAssertEqual(result[0].cipherText, "message")
        XCTAssertEqual(result[0].direction, RelayMessage.Direction.inbound)
        XCTAssertEqual(result[0].timestamp, Date(millisecondsSince1970: 0))
    }

    func test_transform_GetMessagesQueryListWithNils_success() throws {
        let entry = GetMessagesQuery.Data.GetMessage(
            messageId: "dummyId",
            connectionId: "dummyId",
            cipherText: "message",
            direction: Direction.inbound,
            utcTimestamp: utcTimestamp
        )
        let data: [GetMessagesQuery.Data.GetMessage?] = [nil, nil, entry, nil]
        let result = try RelayTransformer.transform(data)
        XCTAssertEqual(result[0].messageId, "dummyId")
        XCTAssertEqual(result[0].connectionId, "dummyId")
        XCTAssertEqual(result[0].cipherText, "message")
        XCTAssertEqual(result[0].direction, RelayMessage.Direction.inbound)

        XCTAssertEqual(result[0].timestamp, Date(millisecondsSince1970: 0))
    }

    // MARK: - Tests: StoreMessage Transformers

    func test_transform_StoreMessage_success() throws {
        let entry = StoreMessageMutation.Data.StoreMessage(
            messageId: "dummyId",
            connectionId: "dummyId",
            cipherText: "message",
            direction: Direction.inbound,
            utcTimestamp: utcTimestamp
        )
        let result = try RelayTransformer.transform(entry)
        XCTAssertEqual(result?.messageId, "dummyId")
        XCTAssertEqual(result?.connectionId, "dummyId")
        XCTAssertEqual(result?.cipherText, "message")
        XCTAssertEqual(result?.direction, RelayMessage.Direction.inbound)
        XCTAssertEqual(result?.timestamp, Date(millisecondsSince1970: 0))
    }

    func test_transform_StoreMessageAsNil_success() throws {
        let input: StoreMessageMutation.Data.StoreMessage? = nil
        let result = try RelayTransformer.transform(input)
        XCTAssertNil(result)
    }

    // MARK: - Tests: OnMessageCreatedSubscription Transformer

    func test_transform_OnMessageCreatedSubscription_success() throws {
        let entry = OnMessageCreatedSubscription.Data.OnMessageCreated(
            messageId: "dummyId",
            connectionId: "dummyId",
            cipherText: "message",
            direction: Direction.inbound,
            utcTimestamp: utcTimestamp
        )
        let result = try RelayTransformer.transform(entry)
        XCTAssertEqual(result.messageId, "dummyId")
        XCTAssertEqual(result.connectionId, "dummyId")
        XCTAssertEqual(result.cipherText, "message")
        XCTAssertEqual(result.direction, RelayMessage.Direction.inbound)
        XCTAssertEqual(result.timestamp, Date(millisecondsSince1970: 0))
    }

    // MARK: - Tests: OnPostBoxDeletedSubscription Transformer

    func test_transform_OnPostBoxDeletedSubscription_success() throws {
        let entry = OnPostBoxDeletedSubscription.Data.OnPostBoxDeleted(
            connectionId: "dummyId",
            remainingMessages: []
        )
        let status = RelayTransformer.transform(entry)
        XCTAssertEqual(status, Status.ok)
    }

    // MARK: - Test: Direction

    func test_transform_Direction() {
        do {
            let expectInbound = try RelayTransformer.transform(Direction.inbound)
            XCTAssertEqual(expectInbound, RelayMessage.Direction.inbound)

            let expectOutbound = try RelayTransformer.transform(Direction.outbound)
            XCTAssertEqual(expectOutbound, RelayMessage.Direction.outbound)
        } catch let error {
            XCTFail("Unexpected error \(error)")
        }

    }
}
