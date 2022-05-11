//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DefaultSudoDIRelayClientSubscribeToMessagesReceived: DefaultSudoDIRelayTestCase {

    // MARK: - Tests

    func test_SubscribeToMessagesReceived_CreatesUseCase() async {
        do {
            _ = try await instanceUnderTest.subscribeToMessagesReceived(withConnectionId: "dummyId") { _ in }
            XCTAssertEqual(mockUseCaseFactory.generateSubscribeToMessagesReceivedUseCaseCallCount, 1)
        } catch {
            XCTFail("Unexpected error \(error)")
        }

    }

    func test_SubscribeToMessagesReceived_ReturnsSubscriptionTokenFromUseCase() async {
        let mockUseCase = MockSubscribeToMessagesReceivedUseCase()
        mockUseCase.executeReturnResult = MockSubscriptionToken()
        mockUseCaseFactory.generateSubscribeToMessagesReceivedUseCaseResult = mockUseCase

        do {
            let returnedToken = try await instanceUnderTest.subscribeToMessagesReceived(withConnectionId: "dummyId") { _ in }
            XCTAssertTrue(returnedToken === mockUseCase.executeReturnResult)
        } catch {
            XCTFail("Unexpected error \(error)")
        }

    }

    func test_SubscribeToMessagesReceived_CallsExecuteOnUseCase() async {
        let mockUseCase = MockSubscribeToMessagesReceivedUseCase()
        mockUseCaseFactory.generateSubscribeToMessagesReceivedUseCaseResult = mockUseCase

        do {
            _ = try await instanceUnderTest.subscribeToMessagesReceived(withConnectionId: "dummyId") { _ in }
            XCTAssertEqual(mockUseCase.executeCallCount, 1)
        } catch {
            XCTFail("Unexpected error \(error)")
        }

    }

    func test_SubscribeToMessagesReceived_RespectsReturnedUseCaseError() async {
        let mockUseCase = MockSubscribeToMessagesReceivedUseCase(result: .failure(AnyError("Failure from subscription")))
        mockUseCaseFactory.generateSubscribeToMessagesReceivedUseCaseResult = mockUseCase

        do {
            _ = try await self.instanceUnderTest.subscribeToMessagesReceived(withConnectionId: "dummyId") { result in
                switch result {
                case let .failure(error as AnyError):
                    XCTAssertEqual(error, AnyError("Failure from subscription"))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_SubscribeToMessagesReceived_ReturnsUseCaseResult() async {
        let outputEntity = DataFactory.Domain.relayMessage
        let mockUseCase = MockSubscribeToMessagesReceivedUseCase(result: .success(outputEntity))
        mockUseCaseFactory.generateSubscribeToMessagesReceivedUseCaseResult = mockUseCase
        do {
            _ = try await self.instanceUnderTest.subscribeToMessagesReceived(withConnectionId: "dummyId") { result in
                switch result {
                case .success(let message):
                    XCTAssertEqual(message.connectionId, "dummyId")
                    XCTAssertEqual(message.messageId, "dummyId")
                    XCTAssertEqual(message.cipherText, "dummyString")
                    XCTAssertEqual(message.direction, RelayMessage.Direction.inbound)
                    XCTAssertEqual(message.timestamp, Date(millisecondsSince1970: 0))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
}
