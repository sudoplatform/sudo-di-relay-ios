//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class RelayTransformerTests: XCTestCase {

    // MARK: - Properties

    let utcTimestamp: Double = 0.0

    // MARK: - Tests: listMessages Transformers

    func test_transform_listMessagesQuery_success() throws {
        let item = ListRelayMessagesQuery.Data.ListRelayMessage.Item(
            id: "message-id",
            createdAtEpochMs: 1.0,
            updatedAtEpochMs: 2.0,
            owner: "owner-id",
            owners: [ListRelayMessagesQuery.Data.ListRelayMessage.Item.Owner(id: "sudo-id", issuer: "sudoplatform.sudoservice")],
            postboxId: "postbox-id",
            message: "message contents"
        )
        let data = ListRelayMessagesQuery.Data.ListRelayMessage(items: [item], nextToken: nil)
        let result = try RelayTransformer.transform(data)
        XCTAssertNil(result.nextToken)
        XCTAssertEqual(result.items.count, 1)
        XCTAssertEqual(result.items[0].id, "message-id")
        XCTAssertEqual(result.items[0].createdAt, Date(millisecondsSince1970: 1.0))
        XCTAssertEqual(result.items[0].updatedAt, Date(millisecondsSince1970: 2.0))
        XCTAssertEqual(result.items[0].ownerId, "owner-id")
        XCTAssertEqual(result.items[0].sudoId, "sudo-id")
        XCTAssertEqual(result.items[0].postboxId, "postbox-id")
        XCTAssertEqual(result.items[0].message, "message contents")
    }

    func test_transform_ListMessagesQueryListWithNextToken_success() throws {
        let entry = ListRelayMessagesQuery.Data.ListRelayMessage.Item(
            id: "message-id",
            createdAtEpochMs: 1.0,
            updatedAtEpochMs: 2.0,
            owner: "owner-id",
            owners: [ListRelayMessagesQuery.Data.ListRelayMessage.Item.Owner(id: "sudo-id", issuer: "sudoplatform.sudoservice")],
            postboxId: "postbox-id",
            message: "message contents"
        )
        let entry_2 = ListRelayMessagesQuery.Data.ListRelayMessage.Item(
                id: "message-id-2",
                createdAtEpochMs: 3.0,
                updatedAtEpochMs: 4.0,
                owner: "owner-id-2",
                owners: [ListRelayMessagesQuery.Data.ListRelayMessage.Item.Owner(id: "sudo-id", issuer: "sudoplatform.sudoservice"),
                         ListRelayMessagesQuery.Data.ListRelayMessage.Item.Owner(id: "other-id", issuer: "sudoplatform.not-sudoservice")],
                postboxId: "postbox-id-2",
                message: "message contents 2"
        )
        let data = ListRelayMessagesQuery.Data.ListRelayMessage(items: [entry, entry_2], nextToken: "nextToken")
        let result = try RelayTransformer.transform(data)

        XCTAssertEqual(result.nextToken, "nextToken")
        XCTAssertEqual(result.items.count, 2)
        XCTAssertEqual(result.items[0].id, "message-id")
        XCTAssertEqual(result.items[0].createdAt, Date(millisecondsSince1970: 1.0))
        XCTAssertEqual(result.items[0].updatedAt, Date(millisecondsSince1970: 2.0))
        XCTAssertEqual(result.items[0].ownerId, "owner-id")
        XCTAssertEqual(result.items[0].sudoId, "sudo-id")
        XCTAssertEqual(result.items[0].postboxId, "postbox-id")
        XCTAssertEqual(result.items[0].message, "message contents")

        XCTAssertEqual(result.items[1].id, "message-id-2")
        XCTAssertEqual(result.items[1].createdAt, Date(millisecondsSince1970: 3.0))
        XCTAssertEqual(result.items[1].updatedAt, Date(millisecondsSince1970: 4.0))
        XCTAssertEqual(result.items[1].ownerId, "owner-id-2")
        XCTAssertEqual(result.items[1].sudoId, "sudo-id")
        XCTAssertEqual(result.items[1].postboxId, "postbox-id-2")
        XCTAssertEqual(result.items[1].message, "message contents 2")
    }

    func test_transform_listMessagesQuery_WithNoValidSudoOwner_throws() throws {
        let item = ListRelayMessagesQuery.Data.ListRelayMessage.Item(
                id: "message-id",
                createdAtEpochMs: 1.0,
                updatedAtEpochMs: 2.0,
                owner: "owner-id",
                owners: [ListRelayMessagesQuery.Data.ListRelayMessage.Item.Owner(id: "sudo-id", issuer: "sudoplatform.not-sudoservice")],
                postboxId: "postbox-id",
                message: "message contents"
        )
        let data = ListRelayMessagesQuery.Data.ListRelayMessage(items: [item], nextToken: nil)
        do {
            _ = try RelayTransformer.transform(data)
            XCTFail("Expected error not thrown.")
        } catch {
            XCTAssertErrorsEqual(error, SudoDIRelayError.invalidMessage)
        }
    }

    // MARK: - Tests: DeleteMessage Transformers

    func test_transform_DeleteMessage_success() throws {
        let entry = DeleteRelayMessageMutation.Data.DeleteRelayMessage(
            id: "message-id"
        )
        let result = try RelayTransformer.transform(entry)
        XCTAssertEqual(result, "message-id")
    }

    // MARK: - Tests: OnMessageCreatedSubscription Transformer

    func test_transform_onMessageCreatedSubscription_success() throws {
        let entry = OnRelayMessageCreatedSubscription.Data.OnRelayMessageCreated(
                id: "message-id",
                createdAtEpochMs: 1.0,
                updatedAtEpochMs: 2.0,
                owner: "owner-id",
                owners: [OnRelayMessageCreatedSubscription.Data.OnRelayMessageCreated.Owner(id: "sudo-id", issuer: "sudoplatform.sudoservice")],
                postboxId: "postbox-id",
                message: "message contents"
        )
        let result = try RelayTransformer.transform(entry)
        XCTAssertEqual(result.id, "message-id")
        XCTAssertEqual(result.createdAt, Date(millisecondsSince1970: 1.0))
        XCTAssertEqual(result.updatedAt, Date(millisecondsSince1970: 2.0))
        XCTAssertEqual(result.ownerId, "owner-id")
        XCTAssertEqual(result.sudoId, "sudo-id")
        XCTAssertEqual(result.postboxId, "postbox-id")
        XCTAssertEqual(result.message, "message contents")
    }

    func test_transform_onMessageCreatedSubscription_WithNoValidSudoOwner_throws() throws {
        let data = OnRelayMessageCreatedSubscription.Data.OnRelayMessageCreated(
                id: "message-id",
                createdAtEpochMs: 1.0,
                updatedAtEpochMs: 2.0,
                owner: "owner-id",
                owners: [OnRelayMessageCreatedSubscription.Data.OnRelayMessageCreated.Owner(id: "sudo-id", issuer: "sudoplatform.not-sudoservice")],
                postboxId: "postbox-id",
                message: "message contents"
        )
        do {
            _ = try RelayTransformer.transform(data)
            XCTFail("Expected error not thrown.")
        } catch {
            XCTAssertErrorsEqual(error, SudoDIRelayError.invalidMessage)
        }
    }

    // MARK: - Tests: listPostboxes Transformers

    func test_transform_listPostboxesQuery_success() throws {
        let item = ListRelayPostboxesQuery.Data.ListRelayPostbox.Item(
            id: "postbox-id",
            createdAtEpochMs: 1.0,
            updatedAtEpochMs: 2.0,
            owner: "owner-id",
            owners: [ListRelayPostboxesQuery.Data.ListRelayPostbox.Item.Owner(id: "sudo-id", issuer: "sudoplatform.sudoservice")],
            connectionId: "connection-id",
            isEnabled: true,
            serviceEndpoint: "https://service_endpoint.com/di-relay"
        )
        let data = ListRelayPostboxesQuery.Data.ListRelayPostbox(items: [item], nextToken: nil)
        let result = try RelayTransformer.transform(data)
        XCTAssertNil(result.nextToken)
        XCTAssertEqual(result.items.count, 1)
        XCTAssertEqual(result.items[0].id, "postbox-id")
        XCTAssertEqual(result.items[0].createdAt, Date(millisecondsSince1970: 1.0))
        XCTAssertEqual(result.items[0].updatedAt, Date(millisecondsSince1970: 2.0))
        XCTAssertEqual(result.items[0].ownerId, "owner-id")
        XCTAssertEqual(result.items[0].sudoId, "sudo-id")
        XCTAssertEqual(result.items[0].connectionId, "connection-id")
        XCTAssertTrue(result.items[0].isEnabled)
        XCTAssertEqual(result.items[0].serviceEndpoint, "https://service_endpoint.com/di-relay")
    }

    func test_transform_ListPostboxesQueryListWithNextToken_success() throws {
        let entry = ListRelayPostboxesQuery.Data.ListRelayPostbox.Item(
                id: "postbox-id",
                createdAtEpochMs: 1.0,
                updatedAtEpochMs: 2.0,
                owner: "owner-id",
                owners: [ListRelayPostboxesQuery.Data.ListRelayPostbox.Item.Owner(id: "sudo-id", issuer: "sudoplatform.sudoservice")],
                connectionId: "connection-id",
                isEnabled: true,
                serviceEndpoint: "https://service_endpoint.com/di-relay"
        )
        let entry_2 = ListRelayPostboxesQuery.Data.ListRelayPostbox.Item(
                id: "postbox-id-2",
                createdAtEpochMs: 3.0,
                updatedAtEpochMs: 4.0,
                owner: "owner-id-2",
                owners: [ListRelayPostboxesQuery.Data.ListRelayPostbox.Item.Owner(id: "sudo-id", issuer: "sudoplatform.sudoservice"),
                         ListRelayPostboxesQuery.Data.ListRelayPostbox.Item.Owner(id: "other-id", issuer: "sudoplatform.not-sudoservice")],
                connectionId: "connection-id-2",
                isEnabled: false,
                serviceEndpoint: "https://service_endpoint.com/di-relay-2"
        )
        let data = ListRelayPostboxesQuery.Data.ListRelayPostbox(items: [entry, entry_2], nextToken: "nextToken")
        let result = try RelayTransformer.transform(data)

        XCTAssertEqual(result.nextToken, "nextToken")
        XCTAssertEqual(result.items.count, 2)
        XCTAssertEqual(result.items[0].id, "postbox-id")
        XCTAssertEqual(result.items[0].createdAt, Date(millisecondsSince1970: 1.0))
        XCTAssertEqual(result.items[0].updatedAt, Date(millisecondsSince1970: 2.0))
        XCTAssertEqual(result.items[0].ownerId, "owner-id")
        XCTAssertEqual(result.items[0].sudoId, "sudo-id")
        XCTAssertEqual(result.items[0].connectionId, "connection-id")
        XCTAssertTrue(result.items[0].isEnabled)
        XCTAssertEqual(result.items[0].serviceEndpoint, "https://service_endpoint.com/di-relay")

        XCTAssertEqual(result.items[1].id, "postbox-id-2")
        XCTAssertEqual(result.items[1].createdAt, Date(millisecondsSince1970: 3.0))
        XCTAssertEqual(result.items[1].updatedAt, Date(millisecondsSince1970: 4.0))
        XCTAssertEqual(result.items[1].ownerId, "owner-id-2")
        XCTAssertEqual(result.items[1].sudoId, "sudo-id")
        XCTAssertEqual(result.items[1].connectionId, "connection-id-2")
        XCTAssertFalse(result.items[1].isEnabled)
        XCTAssertEqual(result.items[1].serviceEndpoint, "https://service_endpoint.com/di-relay-2")
    }

    func test_transform_listPostboxesQuery_WithNoValidSudoOwner_throws() throws {
        let item = ListRelayPostboxesQuery.Data.ListRelayPostbox.Item(
                id: "postbox-id",
                createdAtEpochMs: 1.0,
                updatedAtEpochMs: 2.0,
                owner: "owner-id",
                owners: [ListRelayPostboxesQuery.Data.ListRelayPostbox.Item.Owner(id: "sudo-id", issuer: "sudoplatform.not-sudoservice")],
                connectionId: "connection-id",
                isEnabled: true,
                serviceEndpoint: "https://service_endpoint.com/di-relay"
        )
        let data = ListRelayPostboxesQuery.Data.ListRelayPostbox(items: [item], nextToken: nil)
        do {
            _ = try RelayTransformer.transform(data)
            XCTFail("Expected error not thrown.")
        } catch {
            XCTAssertErrorsEqual(error, SudoDIRelayError.invalidPostbox)
        }
    }

    // MARK: - Tests: UpdatePostbox Transformers

    func test_transform_UpdatePostbox_success() throws {
        let entry = UpdateRelayPostboxMutation.Data.UpdateRelayPostbox(
            id: "postbox-id",
            createdAtEpochMs: 1.0,
            updatedAtEpochMs: 2.0,
            owner: "owner-id",
            owners: [UpdateRelayPostboxMutation.Data.UpdateRelayPostbox.Owner(id: "sudo-id", issuer: "sudoplatform.sudoservice")],
            connectionId: "connection-id",
            isEnabled: true,
            serviceEndpoint: "https://service_endpoint.com/di-relay"
        )
        let result = try RelayTransformer.transform(entry)
        XCTAssertEqual(result.id, "postbox-id")
        XCTAssertEqual(result.createdAt, Date(millisecondsSince1970: 1.0))
        XCTAssertEqual(result.updatedAt, Date(millisecondsSince1970: 2.0))
        XCTAssertEqual(result.ownerId, "owner-id")
        XCTAssertEqual(result.sudoId, "sudo-id")
        XCTAssertEqual(result.connectionId, "connection-id")
        XCTAssertTrue(result.isEnabled)
        XCTAssertEqual(result.serviceEndpoint, "https://service_endpoint.com/di-relay")
    }

    // MARK: - Tests: DeletePostbox Transformers

    func test_transform_DeletePostbox_success() throws {
        let entry = DeleteRelayPostboxMutation.Data.DeleteRelayPostbox(
                id: "postbox-id"
        )
        let result = try RelayTransformer.transform(entry)
        XCTAssertEqual(result, "postbox-id")
    }

}
