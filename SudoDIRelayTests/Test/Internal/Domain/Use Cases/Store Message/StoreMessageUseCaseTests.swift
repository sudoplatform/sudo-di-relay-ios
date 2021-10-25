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

    func test_execute_CallsStoreMessageCorrectly() {
        instanceUnderTest.execute(withConnectionId: "dummyId", message: "message") { _ in }
        XCTAssertEqual(mockRelayService.storeMessageCallCount, 1)
        XCTAssertEqual(mockRelayService.storeMessageLastProperty, "dummyId")
    }

    func test_execute_RespectsStoreMessageFailure() {
        mockRelayService.storeMessageResult = .failure(AnyError("Store failed"))
        waitUntil { done in
            self.instanceUnderTest.execute(withConnectionId: "dummyId", message: "message") { result in
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

    func test_execute_ReturnsMessageStoreMessageSuccessResult() {
        let res = DataFactory.Domain.relayMessage
        mockRelayService.storeMessageResult = .success(res)
        waitUntil { done in
            self.instanceUnderTest.execute(withConnectionId: "dummyId", message: "message") { result in
                defer { done() }
                switch result {
                case .success(let result):
                    XCTAssertEqual(result, res)
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }
}
