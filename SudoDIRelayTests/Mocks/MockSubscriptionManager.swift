//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

@testable import SudoDIRelay

class MockSubscriptionManager: SubscriptionManager {

    func clearMock() {
        addSubscriptionCallCount = 0
        addSubscriptionLastProperty = nil
        removeSubscriptionCallCount = 0
        removeSubscriptionLastProperty = nil
        removeAllSubscriptionsCallCount = 0
    }

    var addSubscriptionCallCount = 0
    var addSubscriptionLastProperty: RelaySubscriptionToken?

    func addSubscription(_ subscription: RelaySubscriptionToken) {
        addSubscriptionCallCount += 1
        addSubscriptionLastProperty = subscription
    }

    var removeSubscriptionCallCount = 0
    var removeSubscriptionLastProperty: String?

    func removeSubscription(withId id: String) {
        removeSubscriptionCallCount += 1
        removeSubscriptionLastProperty = id
    }

    var removeAllSubscriptionsCallCount = 0

    func removeAllSubscriptions() {
        removeAllSubscriptionsCallCount += 1
    }

}
