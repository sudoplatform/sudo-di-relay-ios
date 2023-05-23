//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//
import Foundation
@testable import SudoDIRelay

extension DataFactory {

    enum Domain {
            static var relayMessage: Message {
            return Message(
                id: "message-id",
                createdAt: Date.now,
                updatedAt: Date.now,
                ownerId: "owner-id",
                sudoId: "sudo-id",
                postboxId: "postbox-id",
                message: "message contents"
            )
        }

        static var okStatus: Status {
            return Status.ok
        }

        static var unsuccessfulStatus: Status {
            return Status.unsuccessful
        }
            static var postbox: Postbox {
            return Postbox(
                    id: "postbox-id",
                    createdAt: Date.now,
                    updatedAt: Date.now,
                    ownerId: "owner-id",
                    sudoId: "sudo-id",
                    connectionId: "connection-id",
                    isEnabled: true,
                    serviceEndpoint: "https://service-endpoint"
            )
        }
    }
}
