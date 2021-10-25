//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class GetMessagesUseCaseTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: GetMessagesUseCase!

    var mockRelayService: MockRelayService!

    var connectionId: String!

    // MARK: - Lifecycle

    override func setUp() {
        mockRelayService = MockRelayService()
        instanceUnderTest = GetMessagesUseCase(relayService: mockRelayService)
        connectionId = UUID().uuidString
    }

    // MARK: - Tests

    func test_initializer() {
        let instanceUnderTest = GetMessagesUseCase(relayService: mockRelayService)
        XCTAssertTrue(instanceUnderTest.relayService === mockRelayService)
    }

    func test_execute_CallsGetMessagesCorrectly() {
        instanceUnderTest.execute(withConnectionId: connectionId) { _ in }
        XCTAssertEqual(mockRelayService.getMessagesCallCount, 1)
        XCTAssertEqual(mockRelayService.getMessagesLastProperty, connectionId)
    }

    func test_execute_RespectsGetMessagesFailure() {
        mockRelayService.getMessagesResult = .failure(AnyError("Get failed"))
        waitUntil { done in
            self.instanceUnderTest.execute(withConnectionId: self.connectionId) { result in
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

    func test_execute_ReturnsGetMessagesSuccessResult() {
        let result = [DataFactory.Domain.relayMessage]
        mockRelayService.getMessagesResult = .success(result)
        waitUntil { done in
            self.instanceUnderTest.execute(withConnectionId: self.connectionId) { result in
                defer { done() }
                switch result {
                case .success(let messages):
                    XCTAssertEqual(messages[0].connectionId, "dummyId")
                    XCTAssertEqual(messages[0].messageId, "dummyId")
                    XCTAssertEqual(messages[0].cipherText, "dummyString")
                    XCTAssertEqual(messages[0].direction, RelayMessage.Direction.inbound)
                    XCTAssertEqual(messages[0].timestamp, Date(millisecondsSince1970: 0))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }
}
