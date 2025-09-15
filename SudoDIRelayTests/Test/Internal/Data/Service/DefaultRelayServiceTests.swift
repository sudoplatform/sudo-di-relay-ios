//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
import SudoKeyManager
import SudoLogging
import SudoApiClient
import SudoUser
@testable import SudoDIRelay

class DefaultRelayServiceTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: DefaultRelayService!
    var mockUserClient: MockSudoUserClient!
    var mockSudoApiClient: MockSudoApiClient!
    var logger: Logger!

    let utcTimestamp: Double = 0.0

    // MARK: - Lifecycle

    override func setUp() {
        logger = Logger.testLogger

        self.mockUserClient = MockSudoUserClient()
        self.mockSudoApiClient = MockSudoApiClient()

        instanceUnderTest = DefaultRelayService(userClient: mockUserClient, sudoApiClient: mockSudoApiClient)
        mockUserClient.isSignedInReturn = true
    }

    // MARK: - Tests: listMessages

    func test_listMessages_RespectsErrors() async throws {
        self.mockSudoApiClient.fetchResult = .failure(AnyError("ERROR"))
        do {
            _ = try await instanceUnderTest.listMessages(limit: nil, nextToken: nil)
            XCTFail("Expected error not thrown.")
        } catch {
            self.XCTAssertErrorsEqual(error, SudoDIRelayError.fatalError(description: "Unexpected API operation error: ERROR"))
        }
    }

    func test_listMessages_ReturnsSuccessResult() async throws {

        var dummyListMessagesData: [String: Any] {
            [
                "__typename": "ListRelayMessagesResult",
                "items":
                [
                    [
                        "__typename": "RelayMessage",
                        "id": "message-id",
                        "createdAtEpochMs": 1.0,
                        "updatedAtEpochMs": 2.0,
                        "owner": "owner-id",
                        "owners": [
                            [
                                "__typename": "Owner",
                                "id": "sudo-id",
                                "issuer": "sudoplatform.sudoservice"
                            ]
                        ],
                        "postboxId": "postbox-id",
                        "message": "message contents"
                    ],
                    [
                        "__typename": "RelayMessage",
                        "id": "message-id-2",
                        "createdAtEpochMs": 3.0,
                        "updatedAtEpochMs": 4.0,
                        "owner": "owner-id",
                        "owners": [
                            [
                                "__typename": "Owner",
                                "id": "sudo-id",
                                "issuer": "sudoplatform.sudoservice"
                            ]
                        ],
                        "postboxId": "postbox-id",
                        "message": "message contents two"
                    ]
                ]
            ]
        }
         var expectedResult: ListOutput<Message> {
             ListOutput<Message>(
                 items: [
                     Message(
                         id: "message-id",
                         createdAt: Date(millisecondsSince1970: 1.0),
                         updatedAt: Date(millisecondsSince1970: 2.0),
                         ownerId: "owner-id",
                         sudoId: "sudo-id",
                         postboxId: "postbox-id",
                         message: "message contents"
                    ), Message(
                         id: "message-id-2",
                         createdAt: Date(millisecondsSince1970: 3.0),
                         updatedAt: Date(millisecondsSince1970: 4.0),
                         ownerId: "owner-id",
                         sudoId: "sudo-id",
                         postboxId: "postbox-id",
                         message: "message contents two")
                ],
                 nextToken: nil
             )
        }

        let queryData =  ListRelayMessagesQuery.Data(
            listRelayMessages:
                ListRelayMessagesQuery.Data.ListRelayMessage(snapshot: dummyListMessagesData)
        )

        self.mockSudoApiClient.fetchResult = .success(queryData)

        let messages = try await self.instanceUnderTest.listMessages(limit: nil, nextToken: nil)
        XCTAssertEqual(messages, expectedResult)
    }

    // MARK: - Tests: DeleteMessage

    func test_deleteMessage_RespectsErrors() async throws {
        self.mockSudoApiClient.performResult = .failure(AnyError("Delete Failed"))

        do {
            _ = try await instanceUnderTest.deleteMessage(withMessageId: "message-id")
            XCTFail("Expected error not thrown.")
        } catch {
            self.XCTAssertErrorsEqual(
                error,
                SudoDIRelayError.fatalError(
                    description: "Unexpected API operation error: Delete Failed")
            )
        }
    }

    func test_deleteMessage_ReturnsSuccessResult() async {
        let data = DeleteRelayMessageMutation.Data.DeleteRelayMessage(
            id: "message-id"
        )
        let mutationData = DeleteRelayMessageMutation.Data(deleteRelayMessage: data)
        self.mockSudoApiClient.performResult = .success(mutationData)

        do {
            let result = try await instanceUnderTest.deleteMessage(withMessageId: "message-id")
            XCTAssertEqual(result, "message-id")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Tests: BulkDeleteMessage

    func test_bulkDeleteMessage_RespectsErrors() async throws {
        self.mockSudoApiClient.performResult = .failure(AnyError("Delete Failed"))

        do {
            _ = try await instanceUnderTest.bulkDeleteMessage(withMessageIds: ["message-id-1", "message-id-2"])
            XCTFail("Expected error not thrown.")
        } catch {
            self.XCTAssertErrorsEqual(
                error,
                SudoDIRelayError.fatalError(
                    description: "Unexpected API operation error: Delete Failed")
            )
        }
    }

    func test_bulkDeleteMessage_ReturnsSuccessResult() async {
        let data = BulkDeleteRelayMessageMutation.Data.BulkDeleteRelayMessage(
            items: [
                BulkDeleteRelayMessageMutation.Data.BulkDeleteRelayMessage.Item(id: "message-id-1"),
                BulkDeleteRelayMessageMutation.Data.BulkDeleteRelayMessage.Item(id: "message-id-2")
            ]
        )
        let mutationData = BulkDeleteRelayMessageMutation.Data(bulkDeleteRelayMessage: data)
        self.mockSudoApiClient.performResult = .success(mutationData)

        do {
            let result = try await instanceUnderTest.bulkDeleteMessage(withMessageIds: ["message-id-1", "message-id-2"])
            XCTAssertEqual(result, ["message-id-1", "message-id-2"])
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Tests: CreatePostbox

    func test_createPostbox_RespectsErrors() async {
        self.mockSudoApiClient.performResult = .failure(AnyError("Create Failed"))

        do {
            _ = try await self.instanceUnderTest.createPostbox(
                withConnectionId: "connection-id",
                ownershipProofToken: "ownership-proof",
                isEnabled: true)
            XCTFail("Expected error not thrown.")
        } catch {
            self.XCTAssertErrorsEqual(
                error,
                SudoDIRelayError.fatalError(description: "Unexpected API operation error: Create Failed")
            )
        }
    }

    func test_createPostbox_DoesNotThrowForSuccess() async throws {
        var dummyCreatePostboxData: [String: Any] {
            [
                "__typename": "RelayPostbox",
                "id": "postbox-id",
                "createdAtEpochMs": 1.0,
                "updatedAtEpochMs": 2.0,
                "owner": "owner-id",
                "owners": [
                    [
                        "__typename": "Owner",
                        "id": "sudo-id",
                        "issuer": "sudoplatform.sudoservice"
                    ]
                ],
                "connectionId": "connection-id",
                "isEnabled": true,
                "serviceEndpoint": "https://service-endpoint.com"
            ]
        }

        let expectedResult = Postbox(
            id: "postbox-id",
            createdAt: Date(millisecondsSince1970: 1.0),
            updatedAt: Date(millisecondsSince1970: 2.0),
            ownerId: "owner-id",
            sudoId: "sudo-id",
            connectionId: "connection-id",
            isEnabled: true,
            serviceEndpoint: "https://service-endpoint.com")

        let mutationData = CreateRelayPostboxMutation.Data(
            createRelayPostbox: CreateRelayPostboxMutation.Data.CreateRelayPostbox(snapshot: dummyCreatePostboxData)
        )

        self.mockSudoApiClient.performResult = .success(mutationData)

        do {
            let postbox = try await instanceUnderTest.createPostbox(
                withConnectionId: "connection-id",
                ownershipProofToken: "ownership-proof",
                isEnabled: true)
            XCTAssertEqual(postbox, expectedResult)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Tests: listPostboxes

    func test_listPostboxes_RespectsErrors() async throws {
        self.mockSudoApiClient.fetchResult = .failure(AnyError("List Failed"))

        do {
            _ = try await instanceUnderTest.listPostboxes(limit: nil, nextToken: nil)
            XCTFail("Expected error not thrown.")
        } catch {
            self.XCTAssertErrorsEqual(error, SudoDIRelayError.fatalError(description: "Unexpected API operation error: List Failed"))
        }
    }

    func test_listPostboxes_ReturnsSuccessResult() async  throws {
        var dummyListPostboxesData: [String: Any] {
            [
                "__typename": "ListRelayPostboxesResult",
                "items":
                [
                    [
                        "__typename": "RelayPostbox",
                        "id": "postbox-id",
                        "createdAtEpochMs": 1.0,
                        "updatedAtEpochMs": 2.0,
                        "owner": "owner-id",
                        "owners": [
                            [
                                "__typename": "Owner",
                                "id": "sudo-id",
                                "issuer": "sudoplatform.sudoservice"
                            ]
                        ],
                        "connectionId": "connection-id",
                        "isEnabled": true,
                        "serviceEndpoint": "https://service-endpoint.com"
                    ],
                    [
                        "__typename": "RelayPostbox",
                        "id": "postbox-id-2",
                        "createdAtEpochMs": 3.0,
                        "updatedAtEpochMs": 4.0,
                        "owner": "owner-id",
                        "owners": [
                            [
                                "__typename": "Owner",
                                "id": "sudo-id",
                                "issuer": "sudoplatform.sudoservice"
                            ]
                        ],
                        "connectionId": "connection-id-2",
                        "isEnabled": false,
                        "serviceEndpoint": "https://service-endpoint-2.com"
                    ]
                ]
            ]
        }

        var expectedResult: ListOutput<Postbox> {
            ListOutput<Postbox>(
                items: [
                    Postbox(
                        id: "postbox-id",
                        createdAt: Date(millisecondsSince1970: 1.0),
                        updatedAt: Date(millisecondsSince1970: 2.0),
                        ownerId: "owner-id",
                        sudoId: "sudo-id",
                        connectionId: "connection-id",
                        isEnabled: true,
                        serviceEndpoint: "https://service-endpoint.com"
                   ), Postbox(
                        id: "postbox-id-2",
                        createdAt: Date(millisecondsSince1970: 3.0),
                        updatedAt: Date(millisecondsSince1970: 4.0),
                        ownerId: "owner-id",
                        sudoId: "sudo-id",
                        connectionId: "connection-id-2",
                        isEnabled: false,
                        serviceEndpoint: "https://service-endpoint-2.com")
               ],
                nextToken: nil
            )
       }

       let queryData =  ListRelayPostboxesQuery.Data(
           listRelayPostboxes:
               ListRelayPostboxesQuery.Data.ListRelayPostbox(snapshot: dummyListPostboxesData)
       )

        self.mockSudoApiClient.fetchResult = .success(queryData)

        do {
            let postboxes = try await instanceUnderTest.listPostboxes(limit: nil, nextToken: nil)
            XCTAssertEqual(postboxes, expectedResult)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Tests: UpdatePostbox

    func test_updatePostbox_RespectsErrors() async {
        self.mockSudoApiClient.performResult = .failure(AnyError("Update Failed"))

        do {
            _ = try await self.instanceUnderTest.updatePostbox(
                withPostboxId: "postbox-id",
                isEnabled: true)
            XCTFail("Expected error not thrown.")
        } catch {
            self.XCTAssertErrorsEqual(
                error,
                SudoDIRelayError.fatalError(description: "Unexpected API operation error: Update Failed")
            )
        }
    }

    func test_updatePostbox_DoesNotThrowForSuccess() async throws {
        var dummyUpdatePostboxData: [String: Any] {
            [
                "__typename": "RelayPostbox",
                "id": "postbox-id",
                "createdAtEpochMs": 1.0,
                "updatedAtEpochMs": 2.0,
                "owner": "owner-id",
                "owners": [
                    [
                        "__typename": "Owner",
                        "id": "sudo-id",
                        "issuer": "sudoplatform.sudoservice"
                    ]
                ],
                "connectionId": "connection-id",
                "isEnabled": false,
                "serviceEndpoint": "https://service-endpoint.com"
            ]
        }

        let expectedResult = Postbox(
            id: "postbox-id",
            createdAt: Date(millisecondsSince1970: 1.0),
            updatedAt: Date(millisecondsSince1970: 2.0),
            ownerId: "owner-id",
            sudoId: "sudo-id",
            connectionId: "connection-id",
            isEnabled: false,
            serviceEndpoint: "https://service-endpoint.com")

        let mutationData =  UpdateRelayPostboxMutation.Data(
            updateRelayPostbox: UpdateRelayPostboxMutation.Data.UpdateRelayPostbox(snapshot: dummyUpdatePostboxData)
        )

        self.mockSudoApiClient.performResult = .success(mutationData)

        do {
            let postbox = try await instanceUnderTest.updatePostbox(
                withPostboxId: "postbox-id",
                isEnabled: true)
            XCTAssertEqual(postbox, expectedResult)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Tests: DeletePostbox

    func test_deletePostbox_RespectsErrors() async throws {
        self.mockSudoApiClient.performResult = .failure(AnyError("Delete Failed"))

        do {
            _ = try await instanceUnderTest.deletePostbox(withPostboxId: "postbox-id")
            XCTFail("Expected error not thrown.")
        } catch {
            self.XCTAssertErrorsEqual(
                error,
                SudoDIRelayError.fatalError(
                    description: "Unexpected API operation error: Delete Failed")
            )
        }
    }

    func test_deletePostbox_ReturnsSuccessResult() async {
        let data = DeleteRelayPostboxMutation.Data.DeleteRelayPostbox(
            id: "postbox-id"
        )
        let mutationData = DeleteRelayPostboxMutation.Data(deleteRelayPostbox: data)
        self.mockSudoApiClient.performResult = .success(mutationData)

        do {
            let result = try await instanceUnderTest.deletePostbox(withPostboxId: "postbox-id")
            XCTAssertEqual(result, "postbox-id")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

}
