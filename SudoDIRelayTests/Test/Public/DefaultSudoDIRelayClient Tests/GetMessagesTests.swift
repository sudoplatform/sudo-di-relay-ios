//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
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

    let utcTimestamp = "Thu, 1 Jan 1970 00:00:00 GMT+00"

    // MARK: - Tests: ListMessages

    func test_listMessages_CreatesUseCase() async {
        let mockUseCase = MockListMessagesUseCase()
        mockUseCase.executeResult = []
        mockUseCaseFactory.generateListMessagesUseCaseResult = mockUseCase

        do {
            _ = try await instanceUnderTest.listMessages(withConnectionId: "dummyId")
            XCTAssertEqual(mockUseCaseFactory.generateListMessagesUseCaseCallCount, 1)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_listMessages_CallsUseCaseExecute() async {
        let mockUseCase = MockListMessagesUseCase()
        mockUseCase.executeResult = []
        mockUseCaseFactory.generateListMessagesUseCaseResult = mockUseCase

        do {
            _ = try await instanceUnderTest.listMessages(withConnectionId: "dummyId")
            XCTAssertEqual(mockUseCase.executeCallCount, 1)
            XCTAssertEqual(mockUseCase.executeLastProperty, "dummyId")
        } catch {
            XCTFail("Unexpected error \(error)")
        }

    }

    func test_listMessages_RespectsUseCaseFailure() async {
        let mockUseCase = MockListMessagesUseCase()
        mockUseCase.executeError = AnyError("List failed")
        mockUseCaseFactory.generateListMessagesUseCaseResult = mockUseCase

        do {
            _ = try await instanceUnderTest.listMessages(withConnectionId: "dummyId")
        } catch {
            XCTAssertErrorsEqual(error, AnyError("List failed"))
        }
    }

    func test_listMessages_SuccessResult() async {
        let result = [
            RelayMessage(
                messageId: "dummyId",
                connectionId: "dummyId",
                cipherText: "message",
                direction: RelayMessage.Direction.inbound,
                timestamp: Date(millisecondsSince1970: 0)
            )
        ]
        let mockUseCase = MockListMessagesUseCase(result: result)
        mockUseCaseFactory.generateListMessagesUseCaseResult = mockUseCase
        do {
            let messages = try await self.instanceUnderTest.listMessages(withConnectionId: "dummyId")
            XCTAssert(messages.count == 1)
            XCTAssertEqual(messages[0].connectionId, "dummyId")
            XCTAssertEqual(messages[0].messageId, "dummyId")
            XCTAssertEqual(messages[0].cipherText, "message")
            XCTAssertEqual(messages[0].direction, RelayMessage.Direction.inbound)
            XCTAssertEqual(messages[0].timestamp, Date(millisecondsSince1970: 0))
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
}
