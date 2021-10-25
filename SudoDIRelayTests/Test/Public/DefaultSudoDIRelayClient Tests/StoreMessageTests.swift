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

    func test_storeMessage_CreatesUseCase() {
        instanceUnderTest.storeMessage(withConnectionId: "dummyId", message: "message") { _ in }
        XCTAssertEqual(mockUseCaseFactory.generateStoreMessageUseCaseCallCount, 1)
    }

    func test_storeMessage_CallsUseCaseExecute() {
        let mockUseCase = MockStoreMessageUseCase()
        mockUseCaseFactory.generateStoreMessageUseCaseResult = mockUseCase
        instanceUnderTest.storeMessage(withConnectionId: "dummyId", message: "message") {_ in }
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
        XCTAssertEqual(mockUseCase.executeLastProperties?.connectionId, "dummyId")
        XCTAssertEqual(mockUseCase.executeLastProperties?.message, "message")
    }

    func test_storeMessage_RespectsUseCaseFailure() {
        let mockUseCase = MockStoreMessageUseCase(result: .failure(AnyError("Store failed")))
        mockUseCaseFactory.generateStoreMessageUseCaseResult = mockUseCase
        waitUntil { done in
            self.instanceUnderTest.storeMessage(withConnectionId: "dummyId", message: "message") { result in
                defer { done() }
                switch result {
                case let .failure(error as AnyError):
                    XCTAssertEqual(error, AnyError("Store failed"))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }

    func test_storeMessage_SuccessResult() {
        let mockUseCase = MockStoreMessageUseCase(result: .success(RelayMessage(
            messageId: "dummyId",
            connectionId: "dummyId",
            cipherText: "message",
            direction: RelayMessage.Direction.inbound,
            timestamp: Date(millisecondsSince1970: 0)
        )))
        mockUseCaseFactory.generateStoreMessageUseCaseResult = mockUseCase
        waitUntil { done in
            self.instanceUnderTest.storeMessage(withConnectionId: "dummyId", message: "message") { result in
                defer { done() }
                switch result {
                case .success(let result):
                    XCTAssertEqual(result?.connectionId, "dummyId")
                    XCTAssertEqual(result?.messageId, "dummyId")
                    XCTAssertEqual(result?.cipherText, "message")
                    XCTAssertEqual(result?.direction, RelayMessage.Direction.inbound)
                    XCTAssertEqual(result?.timestamp, Date(millisecondsSince1970: 0))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }
}
