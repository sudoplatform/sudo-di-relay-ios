//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DefaultSudoDIRelayClientGetMessages: DefaultSudoDIRelayTestCase {

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }

    // MARK: - Properties

    let utcTimestamp = "Thu, 1 Jan 1970 00:00:00 GMT+00"

    // MARK: - Tests: GetMessages

    func test_getMessages_CreatesUseCase() {
        instanceUnderTest.getMessages(withConnectionId: "dummyId") { _ in }
        XCTAssertEqual(mockUseCaseFactory.generateGetMessagesUseCaseCallCount, 1)
    }

    func test_getMessages_CallsUseCaseExecute() {
        let mockUseCase = MockGetMessagesUseCase()
        mockUseCaseFactory.generateGetMessagesUseCaseResult = mockUseCase
        instanceUnderTest.getMessages(withConnectionId: "dummyId") {_ in }
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
        XCTAssertEqual(mockUseCase.executeLastProperty, "dummyId")
    }

    func test_getMessages_RespectsUseCaseFailure() {
        let mockUseCase = MockGetMessagesUseCase(result: .failure(AnyError("Get failed")))
        mockUseCaseFactory.generateGetMessagesUseCaseResult = mockUseCase
        waitUntil { done in
            self.instanceUnderTest.getMessages(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case let .failure(error as AnyError):
                    XCTAssertEqual(error, AnyError("Get failed"))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }

    func test_getMessages_SuccessResult() {
        let result = [
            RelayMessage(
                messageId: "dummyId",
                connectionId: "dummyId",
                cipherText: "message",
                direction: RelayMessage.Direction.inbound,
                timestamp: Date(millisecondsSince1970: 0)
            )
        ]
        let mockUseCase = MockGetMessagesUseCase(result: .success(result))
        mockUseCaseFactory.generateGetMessagesUseCaseResult = mockUseCase
        waitUntil { done in
            self.instanceUnderTest.getMessages(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case .success(let result):
                    XCTAssert(result.count == 1)
                    XCTAssertEqual(result[0].connectionId, "dummyId")
                    XCTAssertEqual(result[0].messageId, "dummyId")
                    XCTAssertEqual(result[0].cipherText, "message")
                    XCTAssertEqual(result[0].direction, RelayMessage.Direction.inbound)
                    XCTAssertEqual(result[0].timestamp, Date(millisecondsSince1970: 0))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }
}
