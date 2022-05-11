//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class StoreMessageUseCaseTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: StoreMessageUseCase!

    var mockRelayService: MockRelayService!

    // MARK: - Lifecycle

    override func setUp() {
        self.mockRelayService = MockRelayService()
        self.instanceUnderTest = StoreMessageUseCase(relayService: mockRelayService)
    }

    // MARK: - Tests

    func test_initializer() {
        let instanceUnderTest = StoreMessageUseCase(relayService: mockRelayService)
        XCTAssertTrue(instanceUnderTest.relayService === mockRelayService)
    }

    func test_execute_CallsStoreMessageCorrectly() async {

        do {
            _ = try await instanceUnderTest.execute(withConnectionId: "dummyId", message: "message")
            XCTAssertEqual(mockRelayService.storeMessageCallCount, 1)
            XCTAssertEqual(mockRelayService.storeMessageLastProperty, "dummyId")
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_execute_RespectsStoreMessageFailure() async {
        mockRelayService.storeMessageError = AnyError("Store failed")

        do {
            let result = try await instanceUnderTest.execute(withConnectionId: "dummyid", message: "message")
            XCTFail("Unexpected result \(String(describing: result))")
        } catch {
            XCTAssertErrorsEqual(error, AnyError("Store failed"))
        }
    }

    func test_execute_ReturnsMessageStoreMessageSuccessResult() async {
        let message = DataFactory.Domain.relayMessage
        mockRelayService.storeMessageResult = message

        do {
            let result = try await instanceUnderTest.execute(withConnectionId: "dummyId", message: "message")
            XCTAssertEqual(result, message)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
}
