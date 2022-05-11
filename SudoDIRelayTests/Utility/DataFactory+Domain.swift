//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//
import Foundation
@testable import SudoDIRelay

extension DataFactory {

    enum Domain {

        static var relayMessage: RelayMessage {
            return RelayMessage(
                messageId: "dummyId",
                connectionId: "dummyId",
                cipherText: "dummyString",
                direction: RelayMessage.Direction.inbound,
                timestamp: Date(millisecondsSince1970: 0)
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
                connectionId: "id",
                userId: "userId",
                sudoId: "sudoId",
                timestamp: Date(millisecondsSince1970: 0)
            )
        }
    }
}
