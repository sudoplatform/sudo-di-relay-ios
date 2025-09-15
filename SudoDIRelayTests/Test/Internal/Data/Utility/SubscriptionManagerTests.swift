//
// Copyright © 2025 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
@testable import SudoDIRelay
import XCTest

class SubscriptionManagerTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: DefaultSubscriptionManager!
    var sudoApiClientMock: MockSudoApiClient!

    // MARK: - Lifecycle

    override func setUp() {
        sudoApiClientMock = MockSudoApiClient()
        instanceUnderTest = DefaultSubscriptionManager(
            graphQLClient: sudoApiClientMock,
            logger: .relaySDKLogger
        )
    }

    // MARK: - Tests: Subscribe

    func test_subscribe_withMessageCreatedNotificationType_willCreateSubscription() async throws {
        // given
        let id = UUID().uuidString
        let notificationType = SubscriptionNotificationType.messageCreated
        let subscriber = MockSubscriber()
        let owner = UUID().uuidString

        // when
        await instanceUnderTest.subscribe(id: id, notificationType: notificationType, subscriber: subscriber, owner: owner)

        // then
        XCTAssertTrue(sudoApiClientMock.subscribeCalled)
        let graphQLSubscription = try XCTUnwrap(
            sudoApiClientMock.subscribeParameters?.subscription as? OnRelayMessageCreatedSubscription
        )
        XCTAssertEqual(graphQLSubscription.owner, owner)
        guard let subscription = await instanceUnderTest.subscriptions[notificationType] else {
            return XCTFail("Subscription should not be nil")
        }
        XCTAssertIdentical(subscription.value, sudoApiClientMock.subscribeSubscription)
        XCTAssertFalse(subscription.isConnected)

        guard let subscribed = await instanceUnderTest.subscribers.first?.subscriber else {
            return XCTFail("Subscriber should not be nil")
        }
        XCTAssertIdentical(subscribed, subscriber)
    }

    func test_subscribe_withExistingConnectedSubscription_willNotifySubscribers() async throws {
        // given
        let id = UUID().uuidString
        let notificationType = SubscriptionNotificationType.messageCreated
        let subscriber = MockSubscriber()
        let owner = UUID().uuidString
        let notifyExpectation = expectation(description: "status change notified")

        let existingSubscriber = MockSubscriber()
        existingSubscriber.connectionStatusChangedHandler = { _ in
            notifyExpectation.fulfill()
        }
        await instanceUnderTest.subscribe(
            id: UUID().uuidString,
            notificationType: notificationType,
            subscriber: existingSubscriber,
            owner: owner
        )
        sudoApiClientMock.subscribeParameters?.statusChangeHandler?(.connected)
        await fulfillment(of: [notifyExpectation])

        // when
        await instanceUnderTest.subscribe(id: id, notificationType: notificationType, subscriber: subscriber, owner: owner)

        // then
        XCTAssertTrue(subscriber.connectionStatusChangedCalled)
        XCTAssertEqual(subscriber.state, .connected)
    }

    func test_subscribe_withExistingNotConnectedSubscription_willNotNotifySubscribers() async throws {
        // given
        let id = UUID().uuidString
        let notificationType = SubscriptionNotificationType.messageCreated
        let subscriber = MockSubscriber()
        let owner = UUID().uuidString

        // when
        await instanceUnderTest.subscribe(id: id, notificationType: notificationType, subscriber: subscriber, owner: owner)

        // then
        XCTAssertFalse(subscriber.connectionStatusChangedCalled)
    }

    func test_subscribe_willAllowSameIdWithDifferentNotificationType() async throws {
        // given
        let id = UUID().uuidString
        let owner = UUID().uuidString

        // when
        for notificationType in SubscriptionNotificationType.allCases {
            await instanceUnderTest.subscribe(id: id, notificationType: notificationType, subscriber: MockSubscriber(), owner: owner)
        }

        // then
        let subscriptions = await instanceUnderTest.subscriptions
        let subscribers = await instanceUnderTest.subscribers
        XCTAssertEqual(subscriptions.count, SubscriptionNotificationType.allCases.count)
        XCTAssertEqual(subscribers.count, SubscriptionNotificationType.allCases.count)
    }

    func test_subscribe_withSameIdAndNotificationType_willOverrideExistingInstance() async throws {
        // given
        let id = UUID().uuidString
        let notificationType = SubscriptionNotificationType.messageCreated
        let firstSubscriber = MockSubscriber()
        let secondSubscriber = MockSubscriber()
        let owner = UUID().uuidString
        await instanceUnderTest.subscribe(id: id, notificationType: notificationType, subscriber: firstSubscriber, owner: owner)

        // when
        await instanceUnderTest.subscribe(id: id, notificationType: notificationType, subscriber: secondSubscriber, owner: owner)

        // then
        let subscribers = await instanceUnderTest.subscribers
        XCTAssertEqual(subscribers.count, 1)
        XCTAssertIdentical(subscribers.first?.subscriber, secondSubscriber)
    }

    // MARK: - Tests: Unsubscribe

    func test_unsubscribe_willRemoveSubscriberWithProvidedId() async throws {
        // given
        let id = UUID().uuidString
        let subscriber = MockSubscriber()
        let notificationType = SubscriptionNotificationType.messageCreated
        await instanceUnderTest.subscribe(id: id, notificationType: notificationType, subscriber: subscriber, owner: "")

        // when
        await instanceUnderTest.unsubscribe(id: id)

        // then
        let subscribers = await instanceUnderTest.subscribers
        XCTAssertTrue(subscribers.isEmpty)
    }

    func test_unsubscribe_withNoRemainingSubscribers_willCancelSubscription() async throws {
        // given
        let id = UUID().uuidString
        let owner = UUID().uuidString
        let subscriber = MockSubscriber()
        let notificationType = SubscriptionNotificationType.messageCreated
        let subscription = GraphQLClientSubscriptionMock()
        sudoApiClientMock.subscribeSubscription = subscription
        await instanceUnderTest.subscribe(id: id, notificationType: notificationType, subscriber: subscriber, owner: owner)

        // when
        await instanceUnderTest.unsubscribe(id: id)

        // then
        XCTAssertTrue(subscription.cancelCalled)
    }

    func test_unsubscribe_withRemainingSubscribers_willNotCancelSubscription() async throws {
        // given
        let id = UUID().uuidString
        let owner = UUID().uuidString
        let subscriber = MockSubscriber()
        let notificationType = SubscriptionNotificationType.messageCreated
        let subscription = GraphQLClientSubscriptionMock()
        sudoApiClientMock.subscribeSubscription = subscription
        await instanceUnderTest.subscribe(id: id, notificationType: notificationType, subscriber: subscriber, owner: owner)
        await instanceUnderTest.subscribe(
            id: UUID().uuidString,
            notificationType: notificationType,
            subscriber: MockSubscriber(),
            owner: owner
        )

        // when
        await instanceUnderTest.unsubscribe(id: id)

        // then
        XCTAssertFalse(subscription.cancelCalled)
    }

    func test_unsubscribeAll_willRemoveAllSubscribers_andCancelAllSubscriptions() async throws {
        // given
        var subscriptions: [GraphQLClientSubscriptionMock] = []
        for notificationType in SubscriptionNotificationType.allCases {
            let subscription = GraphQLClientSubscriptionMock()
            subscriptions.append(subscription)
            sudoApiClientMock.subscribeSubscription = subscription
            await instanceUnderTest.subscribe(
                id: UUID().uuidString,
                notificationType: notificationType,
                subscriber: MockSubscriber(),
                owner: UUID().uuidString
            )
        }
        // when
        await instanceUnderTest.unsubscribeAll()

        // then
        for subscription in subscriptions {
            XCTAssertTrue(subscription.cancelCalled)
        }
        let remainingSubscribers = await instanceUnderTest.subscribers
        XCTAssertTrue(remainingSubscribers.isEmpty)
        let remainingSubscriptions = await instanceUnderTest.subscriptions
        XCTAssertTrue(remainingSubscriptions.isEmpty)
    }

    // MARK: - Tests: Events

    func test_subscriptionStatusChange_withConnectedState_willUpdateSubscriptionIsConnected() async throws {
        // given
        let id = UUID().uuidString
        let notificationType = SubscriptionNotificationType.messageCreated
        let subscriber = MockSubscriber()
        let notificationExpectation = expectation(description: "status change")
        subscriber.connectionStatusChangedHandler = { _ in
            notificationExpectation.fulfill()
        }
        await instanceUnderTest.subscribe(
            id: id,
            notificationType: notificationType,
            subscriber: subscriber,
            owner: UUID().uuidString
        )

        // when
        sudoApiClientMock.subscribeParameters?.statusChangeHandler?(.connected)
        await fulfillment(of: [notificationExpectation])

        // then
        let subscription = await instanceUnderTest.subscriptions[notificationType]
        XCTAssertEqual(subscription?.isConnected, true)
    }

    func test_subscriptionStatusChange_withConnectedState_willNotifySubscribers() async throws {
        // given
        let id = UUID().uuidString
        let notificationType = SubscriptionNotificationType.messageCreated
        let subscriber = MockSubscriber()
        let notificationExpectation = expectation(description: "status change")
        subscriber.connectionStatusChangedHandler = { _ in
            notificationExpectation.fulfill()
        }
        await instanceUnderTest.subscribe(
            id: id,
            notificationType: notificationType,
            subscriber: subscriber,
            owner: UUID().uuidString
        )
        // when
        sudoApiClientMock.subscribeParameters?.statusChangeHandler?(.connected)
        await fulfillment(of: [notificationExpectation])

        // then
        XCTAssertTrue(subscriber.connectionStatusChangedCalled)
        XCTAssertEqual(subscriber.state, .connected)
    }

    func test_subscriptionCompletion_willCancelSubscription_andNotifyAndRemoveSubscribers() async throws {
        // given
        let id = UUID().uuidString
        let notificationType = SubscriptionNotificationType.messageCreated
        let subscriber = MockSubscriber()
        let subscription = GraphQLClientSubscriptionMock()
        sudoApiClientMock.subscribeSubscription = subscription

        let notificationExpectation = expectation(description: "status change")
        subscriber.connectionStatusChangedHandler = { _ in
            notificationExpectation.fulfill()
        }
        await instanceUnderTest.subscribe(
            id: id,
            notificationType: notificationType,
            subscriber: subscriber,
            owner: UUID().uuidString
        )
        // when
        sudoApiClientMock.subscribeParameters?.completionHandler?(.success(()))
        await fulfillment(of: [notificationExpectation])

        // then
        XCTAssertTrue(subscription.cancelCalled)
        let subscriptions = await instanceUnderTest.subscriptions
        XCTAssertTrue(subscriptions.isEmpty)

        XCTAssertTrue(subscriber.connectionStatusChangedCalled)
        XCTAssertEqual(subscriber.state, .disconnected)
        let subscribers = await instanceUnderTest.subscribers
        XCTAssertTrue(subscribers.isEmpty)
    }

    func test_subscriptionResult_withSuccessResult_withMessageCreatedType_willNotifySubscribers() async throws {
        // given
        let id = UUID().uuidString
        let messageId = UUID().uuidString
        let ownerId = UUID().uuidString
        
        let notificationType = SubscriptionNotificationType.messageCreated
        let subscriber = MockSubscriber()
        let onMessageCreatedData = OnRelayMessageCreatedSubscription.Data.OnRelayMessageCreated(
            id: messageId,
            createdAtEpochMs: 1,
            updatedAtEpochMs: 2,
            owner: ownerId,
            owners: [OnRelayMessageCreatedSubscription.Data.OnRelayMessageCreated.Owner(id: ownerId, issuer: "sudoplatform.sudoservice")],
            postboxId: UUID().uuidString,
            message: UUID().uuidString
        )
        let data = OnRelayMessageCreatedSubscription.Data(onRelayMessageCreated: onMessageCreatedData)
        let resultExpectation = expectation(description: "result received")
        subscriber.notifyHandler = { _ in
            resultExpectation.fulfill()
        }
        await instanceUnderTest.subscribe(
            id: id,
            notificationType: notificationType,
            subscriber: subscriber,
            owner: ownerId
        )
        // when
        sudoApiClientMock.subscribeParameters?.resultHandler(.success(data))
        await fulfillment(of: [resultExpectation])

        // then
        XCTAssertTrue(subscriber.notifyCalled)
        let notification = try XCTUnwrap(subscriber.notification)
        guard case .messageCreated(let message) = notification else {
            return XCTFail("Incorrect notification sent")
        }
        XCTAssertEqual(message.id, messageId)
    }
}
