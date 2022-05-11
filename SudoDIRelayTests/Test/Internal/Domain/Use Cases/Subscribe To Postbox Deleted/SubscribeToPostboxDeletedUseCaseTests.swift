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

    func test_execute_CallsService() async {
        do {
            _ = try await instanceUnderTest.execute(withConnectionId: "dummyId") { _ in }
            XCTAssertEqual(mockRelayService.subscribeToPostboxDeletedCallCount, 1)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_execute_ReturnsServiceSubscriptionToken() async {
        let returnedToken = MockSubscriptionToken()
        mockRelayService.subscribeToPostboxDeletedReturnResult = returnedToken
        do {
            let token = try await instanceUnderTest.execute(withConnectionId: "dummyId") { _ in }
            XCTAssertTrue(token === returnedToken)

        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_execute_ResolvesToExpectedResult() async {
        let status = DataFactory.Domain.okStatus
        mockRelayService.subscribeToPostboxDeletedResult = .success(status)

        do {
            _ = try await self.instanceUnderTest.execute(withConnectionId: "dummyId") { result in
                switch result {
                case .success(let status):
                    XCTAssertEqual(status, DataFactory.Domain.okStatus)
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_execute_RespectsSubscriptionError() async {
        mockRelayService.subscribeToPostboxDeletedResult = .failure(AnyError("Subscribe failed"))

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
            XCTFail("Unexpected error \(error)")
        }
    }
}
