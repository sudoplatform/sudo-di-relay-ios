//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class SubscriptionManagerTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: DefaultSubscriptionManager!
    var mockCancellable: MockCancellable!
    var mockSubscriptionManager: MockSubscriptionManager!

    // MARK: - Lifecycle

    override func setUp() {
        mockCancellable = MockCancellable()
        mockSubscriptionManager = MockSubscriptionManager()
        instanceUnderTest = DefaultSubscriptionManager()
    }

    // MARK: - Tests

    func test_addSubscription() {
        let subscription = RelaySubscriptionToken(cancellable: mockCancellable, manager: mockSubscriptionManager)
        instanceUnderTest.addSubscription(subscription)
        XCTAssertFalse(instanceUnderTest.subscriptions.isEmpty)
    }

    func test_removeSubscription_RemovesExpectedSubscription() {
        let subscription = RelaySubscriptionToken(cancellable: mockCancellable, manager: mockSubscriptionManager)
        instanceUnderTest.addSubscription(subscription)
        XCTAssertFalse(instanceUnderTest.subscriptions.isEmpty)
        instanceUnderTest.removeSubscription(withId: subscription.id)
        XCTAssertTrue(instanceUnderTest.subscriptions.isEmpty)
    }

    func test_removeSubscription_CancelsRemovedSubscription() {
        let subscription = RelaySubscriptionToken(cancellable: mockCancellable, manager: mockSubscriptionManager)
        instanceUnderTest.addSubscription(subscription)
        instanceUnderTest.removeSubscription(withId: subscription.id)
        XCTAssertEqual(mockCancellable.cancelCalls, 1)
    }

    func test_removeAllSubscriptions_RemovesAllSubscriptions() {
        let cancel1 = MockCancellable()
        let cancel2 = MockCancellable()
        let sub1 = RelaySubscriptionToken(cancellable: cancel1, manager: mockSubscriptionManager)
        let sub2 = RelaySubscriptionToken(cancellable: cancel2, manager: mockSubscriptionManager)
        instanceUnderTest.addSubscription(sub1)
        instanceUnderTest.addSubscription(sub2)
        XCTAssertEqual(instanceUnderTest.subscriptions.count, 2)
        instanceUnderTest.removeAllSubscriptions()
        XCTAssertTrue(instanceUnderTest.subscriptions.isEmpty)
    }

}

class WeakRelaySubscriptionTokenTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: WeakRelaySubscriptionToken!

    var strongRelaySubscriptionToken: RelaySubscriptionToken!
    var mockCancellable: MockCancellable!
    var mockSubscriptionManager: MockSubscriptionManager!

    // MARK: - Lifecycle

    override func setUp() {
        mockCancellable = MockCancellable()
        mockSubscriptionManager = MockSubscriptionManager()
        strongRelaySubscriptionToken = RelaySubscriptionToken(cancellable: mockCancellable, manager: mockSubscriptionManager)
        instanceUnderTest = WeakRelaySubscriptionToken(strongRelaySubscriptionToken)
    }

    // MARK: - Tests

    func test_initializer() throws {
        let instanceUnderTest = WeakRelaySubscriptionToken(strongRelaySubscriptionToken)
        XCTAssertTrue(instanceUnderTest.value === strongRelaySubscriptionToken)
    }

    func test_RespectsWeakReference() {
        XCTAssertNotNil(instanceUnderTest.value)
        strongRelaySubscriptionToken = nil
        mockSubscriptionManager.clearMock()
        XCTAssertNil(instanceUnderTest.value)
    }

    func test_id_ReturnsValueId() {
        XCTAssertEqual(instanceUnderTest.id, strongRelaySubscriptionToken.id)
    }

    func test_id_IDPersistsAFterSubscriptionGone() {
        let expectedId = strongRelaySubscriptionToken.id
        strongRelaySubscriptionToken = nil
        mockSubscriptionManager.clearMock()
        XCTAssertEqual(instanceUnderTest.id, expectedId)
    }

    func test_cancel_CallsValueCancel() {
        instanceUnderTest.cancel()
        XCTAssertEqual(mockCancellable.cancelCalls, 1)
    }

    func test_Equatable() {
        XCTAssertEqual(instanceUnderTest, instanceUnderTest)
    }

    func test_NotEquatable() {
        let secondCancellable = MockCancellable()
        let secondToken = RelaySubscriptionToken(cancellable: secondCancellable, manager: mockSubscriptionManager)
        let secondWeak = WeakRelaySubscriptionToken(secondToken)
        XCTAssertNotEqual(instanceUnderTest, secondWeak)
    }

}
