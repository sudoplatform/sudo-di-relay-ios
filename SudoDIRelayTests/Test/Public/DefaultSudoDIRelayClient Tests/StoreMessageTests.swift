//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DefaultSudoDIRelayClientStoreMessage: DefaultSudoDIRelayTestCase {

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }

    // MARK: - Properties

    let utcTimestamp = "Thu, 1 Jan 1970 00:00:00 GMT+00"

    // MARK: - Tests: StoreMessage

    func test_storeMessage_CreatesUseCase() async {
        do {
            _ = try await instanceUnderTest.storeMessage(withConnectionId: "dummyId", message: "message")
            XCTAssertEqual(mockUseCaseFactory.generateStoreMessageUseCaseCallCount, 1)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_storeMessage_CallsUseCaseExecute() async {
        let mockUseCase = MockStoreMessageUseCase()
        mockUseCaseFactory.generateStoreMessageUseCaseResult = mockUseCase

        do {
            _ = try await instanceUnderTest.storeMessage(withConnectionId: "dummyId", message: "message")
            XCTAssertEqual(mockUseCase.executeCallCount, 1)
            XCTAssertEqual(mockUseCase.executeLastProperties?.connectionId, "dummyId")
            XCTAssertEqual(mockUseCase.executeLastProperties?.message, "message")
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_storeMessage_RespectsUseCaseFailure() async {
        let mockUseCase = MockStoreMessageUseCase()
        mockUseCase.executeError = AnyError("Store failed")
        mockUseCaseFactory.generateStoreMessageUseCaseResult = mockUseCase

        do {
            _ = try await self.instanceUnderTest.storeMessage(withConnectionId: "dummyId", message: "message")
        } catch {
            XCTAssertErrorsEqual(error, AnyError("Store failed"))
        }
    }

    func test_storeMessage_SuccessResult() async {
        let mockUseCase = MockStoreMessageUseCase(result: RelayMessage(
            messageId: "dummyId",
            connectionId: "dummyId",
            cipherText: "message",
            direction: RelayMessage.Direction.inbound,
            timestamp: Date(millisecondsSince1970: 0)
        ))
        mockUseCaseFactory.generateStoreMessageUseCaseResult = mockUseCase

        do {
            let message = try await instanceUnderTest.storeMessage(withConnectionId: "dummyId", message: "message")
            XCTAssertEqual(message?.connectionId, "dummyId")
            XCTAssertEqual(message?.messageId, "dummyId")
            XCTAssertEqual(message?.cipherText, "message")
            XCTAssertEqual(message?.direction, RelayMessage.Direction.inbound)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
}
