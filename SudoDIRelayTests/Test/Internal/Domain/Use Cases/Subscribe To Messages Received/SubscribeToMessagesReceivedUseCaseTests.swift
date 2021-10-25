//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class SubscribeToMessagesReceivedUseCaseTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: SubscribeToMessagesReceivedUseCase!

    var mockRelayService: MockRelayService!

    // MARK: - Lifecycle

    override func setUp() {
        self.mockRelayService = MockRelayService()
        self.instanceUnderTest = SubscribeToMessagesReceivedUseCase(relayService: mockRelayService)
    }

    // MARK: - Tests

    func test_initializer() {
        let instanceUnderTest = SubscribeToMessagesReceivedUseCase(relayService: mockRelayService)
        XCTAssertTrue(instanceUnderTest.relayService === mockRelayService)
    }

    func test_execute_CallsService() throws {
        _ = instanceUnderTest.execute(withConnectionId: "dummyId") { _ in }
        XCTAssertEqual(mockRelayService.subscribeToMessagesReceivedCallCount, 1)
    }

    func test_execute_ReturnsServiceSubscriptionToken() throws {
        let expectedToken = MockSubscriptionToken()
        mockRelayService.subscribeToMessagesReceivedReturnResult = expectedToken
        let token = instanceUnderTest.execute(withConnectionId: "mockId") { _ in }
        XCTAssertTrue(token === expectedToken)
    }

    func test_execute_ResolvesToExpectedResult() throws {
        let message = DataFactory.Domain.relayMessage
        mockRelayService.subscribeToMessagesReceivedResult = .success(message)
        waitUntil { done in
            _ = self.instanceUnderTest.execute(withConnectionId: "dummyId") { result in
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

    func test_execute_RespectsSubscriptionError() throws {
        mockRelayService.subscribeToMessagesReceivedResult = .failure(AnyError("Subscribe failed"))
        waitUntil { done in
            _ = self.instanceUnderTest.execute(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case let .failure(error as AnyError):
                    XCTAssertEqual(error, AnyError("Subscribe failed"))
                    done()
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }
}
