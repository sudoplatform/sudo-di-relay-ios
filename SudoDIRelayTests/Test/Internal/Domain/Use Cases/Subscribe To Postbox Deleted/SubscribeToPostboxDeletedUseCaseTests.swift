//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class SubscribeToPostboxDeletedUseCaseTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: SubscribeToPostboxDeletedUseCase!

    var mockRelayService: MockRelayService!

    // MARK: - Lifecycle

    override func setUp() {
        self.mockRelayService = MockRelayService()
        self.instanceUnderTest = SubscribeToPostboxDeletedUseCase(relayService: mockRelayService)
    }

    // MARK: - Tests

    func test_initializer() {
        let instanceUnderTest = SubscribeToPostboxDeletedUseCase(relayService: mockRelayService)
        XCTAssertTrue(instanceUnderTest.relayService === mockRelayService)
    }

    func test_execute_CallsService() {
        _ = instanceUnderTest.execute(withConnectionId: "dummyId") { _ in }
        XCTAssertEqual(mockRelayService.subscribeToPostboxDeletedCallCount, 1)
    }

    func test_execute_ReturnsServiceSubscriptionToken() throws {
        let returnedToken = MockSubscriptionToken()
        mockRelayService.subscribeToPostboxDeletedReturnResult = returnedToken
        let token = instanceUnderTest.execute(withConnectionId: "dummyId") { _ in }
        XCTAssertTrue(token === returnedToken)
    }

    func test_execute_ResolvesToExpectedResult() throws {
        let status = DataFactory.Domain.okStatus
        mockRelayService.subscribeToPostboxDeletedResult = .success(status)
        waitUntil { done in
            _ = self.instanceUnderTest.execute(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case .success(let status):
                    XCTAssertEqual(status, DataFactory.Domain.okStatus)
                default:
                    XCTFail("Unexpected result: \(result)")
                }
                done()

            }
        }
    }

    func test_execute_RespectsSubscriptionError() throws {
        mockRelayService.subscribeToPostboxDeletedResult = .failure(AnyError("Subscribe failed"))
        waitUntil { done in
            _ = self.instanceUnderTest.execute(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case let .failure(error as AnyError):
                    XCTAssertEqual(error, AnyError("Subscribe failed"))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
                done()
            }
        }
    }
}
