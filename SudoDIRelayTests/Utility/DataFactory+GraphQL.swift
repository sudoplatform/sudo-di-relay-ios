//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

@testable import SudoDIRelay

extension DataFactory {

    enum GraphQL {

        static var createdAtEpochMs: Double {
            return 1.0
        }

        static var updatedAtEpochMs: Double {
            return 2.0
        }

        static var getMessages: GetMessagesQuery.Data {
            let getMessages = GetMessagesQuery.Data.GetMessage(
                messageId: "dummyId",
                connectionId: "dummyId",
                cipherText: "message",
                direction: Direction.inbound,
                utcTimestamp: "Thu, 1 Jan 1970 00:00:00 GMT+00"
            )
            let optionalGetMessages: GetMessagesQuery.Data.GetMessage? = getMessages
            return GetMessagesQuery.Data(getMessages: [optionalGetMessages])
        }

        static var storeMessage: StoreMessageMutation.Data {
            let storeMessage = StoreMessageMutation.Data.StoreMessage(
                messageId: "dummyId",
                connectionId: "dummyId",
                cipherText: "message",
                direction: Direction.inbound,
                utcTimestamp: "Thu, 1 Jan 1970 00:00:00 GMT+00"
            )
            return StoreMessageMutation.Data(storeMessage: storeMessage)
        }

        static var createPostbox: SendInitMutation.Data {
            let createPostbox = SendInitMutation.Data.SendInit(
                messageId: "init",
                connectionId: "dummyId",
                cipherText: "message",
                direction: Direction.inbound,
                utcTimestamp: "Thu, 1 Jan 1970 00:00:00 GMT+00"
            )
            return SendInitMutation.Data(sendInit: createPostbox)
        }

        static var deletePostbox: DeletePostBoxMutation.Data {
            let deletePostbox = DeletePostBoxMutation.Data.DeletePostBox(
                status: 200
            )
            return DeletePostBoxMutation.Data(deletePostBox: deletePostbox)
        }

        static var onMessageCreatedSubscription: OnMessageCreatedSubscription.Data? {
            let onMessageCreatedSubscription = OnMessageCreatedSubscription.Data.OnMessageCreated(
                messageId: "init",
                connectionId: "dummyId",
                cipherText: "message",
                direction: Direction.inbound,
                utcTimestamp: "Thu, 1 Jan 1970 00:00:00 GMT+00"
            )
            return try? OnMessageCreatedSubscription.Data(onMessageCreatedSubscription)
        }

        static var onPostboxDeletedSubscription: OnPostBoxDeletedSubscription.Data? {
            let onPostboxDeletedSubscription = OnPostBoxDeletedSubscription.Data.OnPostBoxDeleted(
                connectionId: "dummyId",
                remainingMessages: [])
            return try? OnPostBoxDeletedSubscription.Data(onPostboxDeletedSubscription)
        }
    }
}
