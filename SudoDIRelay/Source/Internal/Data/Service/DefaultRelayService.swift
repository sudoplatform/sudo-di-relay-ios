//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoLogging
import SudoApiClient
import SudoUser

class DefaultRelayService: RelayService {

    // MARK: - Properties

    /// Used to determine if the user is signed in and access the user owner ID.
    private let userClient: SudoUserClient

    /// Client used to interact with the GraphQL endpoint of the di relay.
    private let sudoApiClient: SudoApiClient

    /// Used to log diagnostic and error information.
    private let logger: Logger

    /// Utility class to manage subscriptions.
    private let subscriptionManager: SubscriptionManager

    // MARK: - Supplementary

    // MARK: - Lifecycle

    init(
         userClient: SudoUserClient,
         sudoApiClient: SudoApiClient,
         logger: Logger = .relaySDKLogger
    ) {
        self.userClient = userClient
        self.sudoApiClient = sudoApiClient
        self.logger = logger
        self.subscriptionManager = DefaultSubscriptionManager(
            graphQLClient: sudoApiClient,
            logger: logger
        )
    }

    // MARK: - Conformance: RelayService

    func listMessages(limit: Int? = nil, nextToken: String? = nil) async throws -> ListOutput<Message> {
        let query = ListRelayMessagesQuery(limit: limit, nextToken: nextToken)

        let data = try await GraphQLHelper.performQuery(graphQLClient: sudoApiClient, query: query)
        let messageList = data.listRelayMessages
        return try RelayTransformer.transform(messageList)
    }

    func listPostboxes(limit: Int? = nil, nextToken: String? = nil) async throws -> ListOutput<Postbox> {
        let query = ListRelayPostboxesQuery(limit: limit, nextToken: nextToken)

        let data = try await GraphQLHelper.performQuery(graphQLClient: sudoApiClient, query: query)
        let postboxList = data.listRelayPostboxes
        return try RelayTransformer.transform(postboxList)
    }

    func createPostbox(withConnectionId connectionId: String, ownershipProofToken: String, isEnabled: Bool? = true) async throws -> Postbox {
        let input = CreateRelayPostboxInput(ownershipProof: ownershipProofToken, connectionId: connectionId, isEnabled: isEnabled ?? true)
        let mutation = CreateRelayPostboxMutation(input: input)
        let data = try await GraphQLHelper.performMutation(graphQLClient: sudoApiClient, mutation: mutation)

        return try RelayTransformer.transform(data.createRelayPostbox)
    }

    func updatePostbox(withPostboxId postboxId: String, isEnabled: Bool?) async throws -> Postbox {
        let input = UpdateRelayPostboxInput(postboxId: postboxId, isEnabled: isEnabled)
        let mutation = UpdateRelayPostboxMutation(input: input)
        let data = try await GraphQLHelper.performMutation(graphQLClient: sudoApiClient, mutation: mutation)

        return try RelayTransformer.transform(data.updateRelayPostbox)
    }

    func deletePostbox(withPostboxId postboxId: String) async throws -> String {
        let input = DeleteRelayPostboxInput(postboxId: postboxId)
        let mutation = DeleteRelayPostboxMutation(input: input)
        _ = try await GraphQLHelper.performMutation(graphQLClient: sudoApiClient, mutation: mutation)

        return postboxId
    }

    func deleteMessage(withMessageId messageId: String) async throws -> String {
        let input = DeleteRelayMessageInput(messageId: messageId)
        let mutation = DeleteRelayMessageMutation(input: input)
        _ = try await GraphQLHelper.performMutation(graphQLClient: sudoApiClient, mutation: mutation)

        return messageId
    }

    func bulkDeleteMessage(withMessageIds messageIds: [String]) async throws -> [String] {
        let input = BulkDeleteRelayMessageInput(messageIds: messageIds)
        let mutation = BulkDeleteRelayMessageMutation(input: input)
        _ = try await GraphQLHelper.performMutation(graphQLClient: sudoApiClient, mutation: mutation)

        return messageIds
    }

    // MARK: - Subscriptions
    
    public func subscribe(id: String, notificationType: SubscriptionNotificationType, subscriber: Subscriber) async throws {
        guard let owner = try? await userClient.getSubject() else {
            throw SudoDIRelayError.notSignedIn
        }
        await subscriptionManager.subscribe(id: id, notificationType: notificationType, subscriber: subscriber, owner: owner)
    }

    public func unsubscribe(id: String) async {
        await subscriptionManager.unsubscribe(id: id)
    }

    public func unsubscribeAll() async {
        await subscriptionManager.unsubscribeAll()
    }
}
