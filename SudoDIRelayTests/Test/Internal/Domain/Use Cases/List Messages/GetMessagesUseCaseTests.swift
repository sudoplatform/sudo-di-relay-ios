//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class ListMessagesUseCaseTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: ListMessagesUseCase!
    var mockRelayService: MockRelayService!

    // MARK: - Lifecycle

    override func setUp() {
        mockRelayService = MockRelayService()
        instanceUnderTest = ListMessagesUseCase(relayService: mockRelayService)
    }

    // MARK: - Tests

    func test_initializer() {
        let instanceUnderTest = ListMessagesUseCase(relayService: mockRelayService)
        XCTAssertTrue(instanceUnderTest.relayService === mockRelayService)
    }

    func test_execute_CallsListMessagesCorrectly() async {
        mockRelayService.listMessagesResult = []
        do {
            _ = try await instanceUnderTest.execute(withConnectionId: "dummyId")
            XCTAssertEqual(mockRelayService.listMessagesCallCount, 1)
            XCTAssertEqual(mockRelayService.listMessagesLastProperty, "dummyId")
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_execute_RespectsListMessagesFailure() async {
        mockRelayService.listMessagesError = AnyError("List messages failed")

        do {
            let result = try await instanceUnderTest.relayService.listMessages(withConnectionId: "dummyId")
            XCTFail("Unexpected success \(result)")
        } catch {
            XCTAssertErrorsEqual(error, AnyError("List messages failed"))
        }
    }

    func test_execute_ReturnsListMessagesSuccessResult() async {
        let result = [DataFactory.Domain.relayMessage]
        mockRelayService.listMessagesResult = result

        do {
            let result = try await instanceUnderTest.execute(withConnectionId: "dummyId")
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result[0].connectionId, "dummyId")
            XCTAssertEqual(result[0].messageId, "dummyId")
            XCTAssertEqual(result[0].cipherText, "dummyString")
            XCTAssertEqual(result[0].direction, RelayMessage.Direction.inbound)
            XCTAssertEqual(result[0].timestamp, Date(millisecondsSince1970: 0))
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
}
