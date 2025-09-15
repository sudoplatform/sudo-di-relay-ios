//
// Copyright © 2025 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `Subscriber` conforming objects can be notified of subscription notifications and status changes.
public protocol Subscriber: AnyObject {

    /// Notifies the subscriber of a change.
    /// - Parameter notification: Change notification.
    func notify(notification: SubscriptionNotification)

    /// Notifies the subscriber that the subscription connection state has changed. The subscriber won't be
    /// notified of changes until the connection status changes to `connected`. The subscriber will
    /// stop receiving change notifications when the connection state changes to `disconnected`.
    /// - Parameter state: Connection state.
    func connectionStatusChanged(state: SubscriptionConnectionState)
}
