//
// Copyright © 2025 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The types of notifications that can be sent to `Subscriber` instances.
public enum SubscriptionNotification: Equatable {
    /// A relay message has been created.
    case messageCreated(Message)
}
