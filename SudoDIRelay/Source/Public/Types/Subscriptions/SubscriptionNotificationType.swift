//
// Copyright © 2025 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The types of notifications that `Subscriber` instances can subscribe to.
public enum SubscriptionNotificationType: Equatable, CaseIterable {
    /// Sent when a relay message is created.
    case messageCreated
}
