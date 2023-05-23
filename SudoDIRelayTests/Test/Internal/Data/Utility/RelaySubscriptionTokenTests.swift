//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class RelaySubscriptionTokenTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: RelaySubscriptionToken!

    var mockCancellable: MockCancellable!
    var mockSubscriptionManager: MockSubscriptionManager!

    // MARK: - Lifecycle

    override func setUp() {
        mockCancellable = MockCancellable()
        mockSubscriptionManager = MockSubscriptionManager()
        instanceUnderTest = RelaySubscriptionToken(cancellable: mockCancellable, manager: mockSubscriptionManager)
        mockSubscriptionManager.clearMock()
    }

    // MARK: - Tests

    func test_init() {
        let instanceUnderTest = RelaySubscriptionToken(id: "token-id", cancellable: mockCancellable, manager: mockSubscriptionManager)
        XCTAssertEqual(instanceUnderTest.id, "token-id")
        XCTAssertTrue(instanceUnderTest.subscriptionReference === mockCancellable)
        XCTAssertTrue(instanceUnderTest.manager === mockSubscriptionManager)
    }

    func test_init_NewUUIDEachTimeByDefault() {
        let one = RelaySubscriptionToken(cancellable: mockCancellable, manager: mockSubscriptionManager)
        let two = RelaySubscriptionToken(cancellable: mockCancellable, manager: mockSubscriptionManager)
        XCTAssertNotEqual(one.id, two.id)
    }

    func test_deinit_CancelsSubscription() {
        instanceUnderTest = nil
        XCTAssertEqual(mockCancellable.cancelCalls, 1)
    }

    func test_deinit_RemoveSubscriptionFromManager() {
        let id = instanceUnderTest.id
        instanceUnderTest = nil
        XCTAssertEqual(mockSubscriptionManager.removeSubscriptionCallCount, 1)
        XCTAssertEqual(mockSubscriptionManager.removeSubscriptionLastProperty, id)
    }

    func test_deinit_DoesNotCancelIfAlreadyCancelled() {
        instanceUnderTest.cancel()
        instanceUnderTest = nil
        XCTAssertEqual(mockCancellable.cancelCalls, 1)
    }

    func test_cancel_CancelsSubscription() {
        instanceUnderTest.cancel()
        XCTAssertEqual(mockCancellable.cancelCalls, 1)
    }

    func test_cancel_RemovesSubscriptionReference() {
        instanceUnderTest.cancel()
        XCTAssertNil(instanceUnderTest.subscriptionReference)
    }

    func test_Equatable() {
        let one = instanceUnderTest
        let two = instanceUnderTest
        XCTAssertEqual(one, two)
    }

    func test_NotEquatable() {
        let one = RelaySubscriptionToken(id: "1", cancellable: mockCancellable, manager: mockSubscriptionManager)
        let two = RelaySubscriptionToken(id: "2", cancellable: mockCancellable, manager: mockSubscriptionManager)
        XCTAssertNotEqual(one, two)
    }

    func test_Hashable() {
        var expectedHasher = Hasher()
        expectedHasher.combine("token-id")
        let expectedResult = expectedHasher.finalize()
        var actualHasher = Hasher()
        let instanceUnderTest = RelaySubscriptionToken(id: "token-id", cancellable: mockCancellable, manager: mockSubscriptionManager)
        actualHasher.combine(instanceUnderTest)
        let actualResult = actualHasher.finalize()
        XCTAssertEqual(actualResult, expectedResult)
    }

}
