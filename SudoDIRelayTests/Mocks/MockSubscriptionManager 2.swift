//
// Copyright © 2025 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
@testable import SudoEmail

class MockSubscriptionManager: SubscriptionManager {

    var subscribeCalled = false
    var subscribeParameters: (id: String, notificationType: SubscriptionNotificationType, subscriber: Subscriber, owner: String)?

    func subscribe(id: String, notificationType: SubscriptionNotificationType, subscriber: Subscriber, owner: String) async {
        subscribeCalled = true
        subscribeParameters = (id, notificationType, subscriber, owner)
    }

    var unsubscribeCalled = false
    var unsubscribeParameters: (id: String, Void)?

    func unsubscribe(id: String) async {
        unsubscribeCalled = true
        unsubscribeParameters = (id, ())
    }

    var unsubscribeAllCalled = false

    func unsubscribeAll() async {
        unsubscribeAllCalled = true
    }
}

class MockSubscriber: SudoEmail.Subscriber {

    var id: String = UUID().uuidString
    var notifyCalled = false
    var connectionStatusChangedCalled = false
    var notification: SubscriptionNotification?
    var state: SubscriptionConnectionState?
    var notifyHandler: ((SubscriptionNotification) -> Void)?
    var connectionStatusChangedHandler: ((SubscriptionConnectionState) -> Void)?

    func notify(notification: SubscriptionNotification) {
        notifyCalled = true
        self.notification = notification
        notifyHandler?(notification)
    }

    func connectionStatusChanged(state: SubscriptionConnectionState) {
        connectionStatusChangedCalled = true
        self.state = state
        connectionStatusChangedHandler?(state)
    }
}
