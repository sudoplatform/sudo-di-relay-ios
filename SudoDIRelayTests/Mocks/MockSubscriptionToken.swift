//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

@testable import SudoDIRelay

class MockSubscriptionToken: SubscriptionToken {

    var cancelCallCount = 0

    func cancel() {
        cancelCallCount += 1
    }

}
