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

    func test_execute_CallsService() async {
        do {
            _ = try await instanceUnderTest.execute(withConnectionId: "dummyId") { _ in }
            XCTAssertEqual(mockRelayService.subscribeToMessagesReceivedCallCount, 1)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_execute_ReturnsServiceSubscriptionToken() async {
        let expectedToken = MockSubscriptionToken()
        mockRelayService.subscribeToMessagesReceivedReturnResult = expectedToken

        do {
            let token = try await instanceUnderTest.execute(withConnectionId: "mockId") { _ in }
            XCTAssertTrue(token === expectedToken)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_execute_ResolvesToExpectedResult() async {
        let message = DataFactory.Domain.relayMessage
        mockRelayService.subscribeToMessagesReceivedResult = .success(message)
        do {
            _ = try await self.instanceUnderTest.execute(withConnectionId: "dummyId") { result in
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
            XCTFail("Unexpected result: \(error)")
        }
    }

    func test_execute_RespectsSubscriptionError() async {
        mockRelayService.subscribeToMessagesReceivedResult = .failure(AnyError("Subscribe failed"))

        do {
            _ = try await self.instanceUnderTest.execute(withConnectionId: "dummyId") { result in
                switch result {
                case let .failure(error as AnyError):
                    XCTAssertEqual(error, AnyError("Subscribe failed"))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        } catch {
            XCTFail("Unexpected result: \(error)")
        }
    }
}
