//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DefaultSudoDIRelayClientSubscribeToMessagesReceived: DefaultSudoDIRelayTestCase {

    // MARK: - Tests

    func test_SubscribeToMessagesReceived_CreatesUseCase() {
        _ = instanceUnderTest.subscribeToMessagesReceived(withConnectionId: "dummyId") { _ in }
        XCTAssertEqual(mockUseCaseFactory.generateSubscribeToMessagesReceivedUseCaseCallCount, 1)
    }

    func test_SubscribeToMessagesReceived_ReturnsSubscriptionTokenFromUseCase() {
        let mockUseCase = MockSubscribeToMessagesReceivedUseCase()
        mockUseCase.executeReturnResult = MockSubscriptionToken()
        mockUseCaseFactory.generateSubscribeToMessagesReceivedUseCaseResult = mockUseCase
        let returnedToken = instanceUnderTest.subscribeToMessagesReceived(withConnectionId: "dummyId") { _ in }
        XCTAssertTrue(returnedToken === mockUseCase.executeReturnResult)
    }

    func test_SubscribeToMessagesReceived_CallsExecuteOnUseCase() {
        let mockUseCase = MockSubscribeToMessagesReceivedUseCase()
        mockUseCaseFactory.generateSubscribeToMessagesReceivedUseCaseResult = mockUseCase
        _ = instanceUnderTest.subscribeToMessagesReceived(withConnectionId: "dummyId") { _ in }
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
    }

    func test_SubscribeToMessagesReceived_RespectsReturnedUseCaseError() {
        let mockUseCase = MockSubscribeToMessagesReceivedUseCase(result: .failure(AnyError("Failure from subscription")))
        mockUseCaseFactory.generateSubscribeToMessagesReceivedUseCaseResult = mockUseCase
        waitUntil { done in
            _ = self.instanceUnderTest.subscribeToMessagesReceived(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case let .failure(error as AnyError):
                    XCTAssertEqual(error, AnyError("Failure from subscription"))
                    done()
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }

    func test_SubscribeToMessagesReceived_ReturnsUseCaseResult() {
        let outputEntity = DataFactory.Domain.relayMessage
        let mockUseCase = MockSubscribeToMessagesReceivedUseCase(result: .success(outputEntity))
        mockUseCaseFactory.generateSubscribeToMessagesReceivedUseCaseResult = mockUseCase
        waitUntil { done in
            _ = self.instanceUnderTest.subscribeToMessagesReceived(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case .success(let message):
                    XCTAssertEqual(message.connectionId, "dummyId")
                    XCTAssertEqual(message.messageId, "dummyId")
                    XCTAssertEqual(message.cipherText, "dummyString")
                    XCTAssertEqual(message.direction, RelayMessage.Direction.inbound)
                    XCTAssertEqual(message.timestamp, Date(millisecondsSince1970: 0))
                    done()
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }
}
