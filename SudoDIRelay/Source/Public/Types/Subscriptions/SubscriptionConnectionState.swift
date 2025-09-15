//
// Copyright © 2025 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// The different states that a `Subscription` can be in.
public enum SubscriptionConnectionState: Equatable {
    /// The subscription is currently connected.
    case connected
    /// The subscription is not connected.
    case disconnected
}
