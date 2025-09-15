//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//
import Foundation
@testable import SudoDIRelay

extension DataFactory {

    enum GraphQL {

        static var timestamp: Double { return 0.0 }

        static var createdAtEpochMs: Double {
            return 1.0
        }

        static var updatedAtEpochMs: Double {
            return 2.0
        }

        static var emptyListMessages: ListRelayMessagesQuery.Data {
            let listMessages = ListRelayMessagesQuery.Data.ListRelayMessage(items: [], nextToken: nil)
            return ListRelayMessagesQuery.Data(listRelayMessages: listMessages)
        }
        static var listMessages: ListRelayMessagesQuery.Data {
            let listMessages = ListRelayMessagesQuery.Data.ListRelayMessage(
                    items: [
                        ListRelayMessagesQuery.Data.ListRelayMessage.Item(
                            id: "message-id",
                            createdAtEpochMs: createdAtEpochMs,
                            updatedAtEpochMs: updatedAtEpochMs,
                            owner: "owner-id",
                            owners: [ListRelayMessagesQuery.Data.ListRelayMessage.Item.Owner(id: "sudo-id", issuer: "sudoplatform.sudoservice")],
                            postboxId: "postbox-id",
                            message: "message-contents"),
                        ListRelayMessagesQuery.Data.ListRelayMessage.Item(
                            id: "message-id-2",
                            createdAtEpochMs: createdAtEpochMs,
                            updatedAtEpochMs: updatedAtEpochMs,
                            owner: "owner-id-2",
                            owners: [ListRelayMessagesQuery.Data.ListRelayMessage.Item.Owner(id: "sudo-id-2", issuer: "sudoplatform.sudoservice")],
                            postboxId: "postbox-id-2",
                            message: "message-contents-2")
                    ],
                    nextToken: nil)
            return ListRelayMessagesQuery.Data(listRelayMessages: listMessages)
        }

        static var deleteMessage: DeleteRelayMessageMutation.Data {
            let deleteMessage = DeleteRelayMessageMutation.Data.DeleteRelayMessage(
                    id: "message-id"
            )
            return DeleteRelayMessageMutation.Data(deleteRelayMessage: deleteMessage)
        }

        static var createPostbox: CreateRelayPostboxMutation.Data {
            let createPostbox = CreateRelayPostboxMutation.Data.CreateRelayPostbox(
                id: "postbox-id",
                createdAtEpochMs: createdAtEpochMs,
                updatedAtEpochMs: updatedAtEpochMs,
                owner: "owner-id",
                owners: [CreateRelayPostboxMutation.Data.CreateRelayPostbox.Owner(id: "sudo-id", issuer: "sudoplatform.sudoservice")],
                connectionId: "connection-id",
                isEnabled: true,
                serviceEndpoint: "https://service-endpoint.com"
            )
            return CreateRelayPostboxMutation.Data(createRelayPostbox: createPostbox)
        }

        static var emptyListPostboxes: ListRelayPostboxesQuery.Data {
            let listPostboxes = ListRelayPostboxesQuery.Data.ListRelayPostbox(items: [], nextToken: nil)
            return ListRelayPostboxesQuery.Data(listRelayPostboxes: listPostboxes)
        }

        static var listPostboxes: ListRelayPostboxesQuery.Data {
            let listPostboxes = ListRelayPostboxesQuery.Data.ListRelayPostbox(
                    items: [
                        ListRelayPostboxesQuery.Data.ListRelayPostbox.Item(
                                id: "postbox-id",
                                createdAtEpochMs: createdAtEpochMs,
                                updatedAtEpochMs: updatedAtEpochMs,
                                owner: "owner-id",
                                owners: [ListRelayPostboxesQuery.Data.ListRelayPostbox.Item.Owner(id: "sudo-id", issuer: "sudoplatform.sudoservice")],
                                connectionId: "connection-id",
                                isEnabled: true,
                                serviceEndpoint: "https://service-endpoint"),
                        ListRelayPostboxesQuery.Data.ListRelayPostbox.Item(
                                id: "postbox-id-2",
                                createdAtEpochMs: createdAtEpochMs,
                                updatedAtEpochMs: updatedAtEpochMs,
                                owner: "owner-id-2",
                                owners: [ListRelayPostboxesQuery.Data.ListRelayPostbox.Item.Owner(id: "sudo-id-2", issuer: "sudoplatform.sudoservice")],
                                connectionId: "connection-id-2",
                                isEnabled: false,
                                serviceEndpoint: "https://service-endpoint-2")
                    ],
                    nextToken: nil)
            return ListRelayPostboxesQuery.Data(listRelayPostboxes: listPostboxes)
        }
        static var deletePostbox: DeleteRelayPostboxMutation.Data {
            let deletePostbox = DeleteRelayPostboxMutation.Data.DeleteRelayPostbox(
                id: "postbox-id"
            )
            return DeleteRelayPostboxMutation.Data(deleteRelayPostbox: deletePostbox)
        }

        static var onMessageCreatedSubscription: OnRelayMessageCreatedSubscription.Data? {
            let onMessageCreatedSubscription = OnRelayMessageCreatedSubscription.Data.OnRelayMessageCreated(
                    id: "message-id",
                    createdAtEpochMs: createdAtEpochMs,
                    updatedAtEpochMs: updatedAtEpochMs,
                    owner: "owner-id",
                    owners: [OnRelayMessageCreatedSubscription.Data.OnRelayMessageCreated.Owner(id: "sudo-id", issuer: "sudoplatform.sudoservice")],
                    postboxId: "postbox-id",
                    message: "message contents"
            )
            return OnRelayMessageCreatedSubscription.Data(
                onRelayMessageCreated: onMessageCreatedSubscription
            )
        }
    }
}
