//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//
// swiftlint:disable nesting

import SudoLogging
import SudoConfigManager
import SudoUser
import SudoApiClient

/// Default Client API Endpoint for interacting with the Relay Service.
public class DefaultSudoDIRelayClient: SudoDIRelayClient {

    // MARK: - Supplementary

    /// Configuration parameter names.
    public struct Config {

        /// Configuration namespace.
        struct Namespace {

            /// Relay service related configuration.
            static let RelayService = "relayService"
        }
    }

    // MARK: - Properties

    /// Used to log diagnostic and error information.
    let logger: Logger

    /// Client used to authenticate to Sudo Platform.
    let sudoUserClient: SudoUserClient

    /// App sync client for performing operations against the relay service.
    let sudoApiClient: SudoApiClient

    /// Relay service that does the work of interacting with the service via GraphQL.
    let relayService: RelayService

    // MARK: - Lifecycle

    /// Initialize an instance of `DefaultSudoDIRelayClient`. It uses configuration parameters defined in
    /// `sudoplatformconfig.json` file located in the app bundle.
    /// - Parameters:
    ///   - sudoUserClient: SudoUserClient instance used for authenticating to the backend..
    /// Throws:
    ///     - `SudoDIRelayError` if invalid config.
    public convenience init(sudoUserClient: SudoUserClient) throws {
        // Get the SudoApiClient from the Manager and provide it with the Relay Service config.
        guard let sudoApiClient = try SudoApiClientManager.instance?.getClient(
            sudoUserClient: sudoUserClient, 
            configNamespace: Config.Namespace.RelayService
        ) else {
            throw SudoDIRelayError.invalidConfig
        }

        let relayService = DefaultRelayService(userClient: sudoUserClient, sudoApiClient: sudoApiClient)

        self.init(
            sudoApiClient: sudoApiClient,
            sudoUserClient: sudoUserClient,
            relayService: relayService
        )
    }

    /// Initialize an instance of `DefaultSudoDIRelayClient`.
    ///
    /// This is used internally for injection and mock testing.
    internal init(
        sudoApiClient: SudoApiClient,
        sudoUserClient: SudoUserClient,
        relayService: RelayService,
        logger: Logger = .relaySDKLogger
    ) {
        self.sudoApiClient = sudoApiClient
        self.sudoUserClient = sudoUserClient
        self.relayService = relayService
        self.logger = logger
    }
    // MARK: - Methods

    public func reset() async throws {
        logger.info("Resetting client state.")
        await relayService.unsubscribeAll()
    }

    // MARK: - Conformance: SudoDIRelayClient

    public func listPostboxes(limit: Int? = nil, nextToken: String? = nil) async throws -> ListOutput<Postbox> {
        try await relayService.listPostboxes(limit: limit, nextToken: nextToken)
    }

    public func listMessages(limit: Int? = nil, nextToken: String? = nil) async throws -> ListOutput<Message> {
        try await relayService.listMessages(limit: limit, nextToken: nextToken)
    }

    public func createPostbox(withConnectionId connectionId: String, ownershipProofToken: String, isEnabled: Bool? = true) async throws -> Postbox {
        try await relayService.createPostbox(withConnectionId: connectionId, ownershipProofToken: ownershipProofToken, isEnabled: isEnabled)
    }

    public func updatePostbox(withPostboxId postboxId: String, isEnabled: Bool? = nil) async throws -> Postbox {
        try await relayService.updatePostbox(withPostboxId: postboxId, isEnabled: isEnabled)
    }

    public func deletePostbox(withPostboxId postboxId: String) async throws -> String {
        try await relayService.deletePostbox(withPostboxId: postboxId)
    }

    public func deleteMessage(withMessageId messageId: String) async throws -> String {
        try await relayService.deleteMessage(withMessageId: messageId)
    }

    public func bulkDeleteMessage(withMessageIds messageIds: [String]) async throws -> [String] {
        try await relayService.bulkDeleteMessage(withMessageIds: messageIds)
    }
    
    public func subscribe(id: String, notificationType: SubscriptionNotificationType, subscriber: Subscriber) async throws {
        try await relayService.subscribe(
            id: id,
            notificationType: notificationType,
            subscriber: subscriber
        )
    }
    
    public func unsubscribe(id: String) async {
        await relayService.unsubscribe(id: id)
    }

    public func unsubscribeAll() async {
        await relayService.unsubscribeAll()
    }
}
