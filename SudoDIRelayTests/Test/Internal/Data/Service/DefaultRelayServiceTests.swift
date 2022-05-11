//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
import AWSAppSync
import SudoKeyManager
import SudoLogging
import SudoApiClient
import SudoUser
@testable import SudoDIRelay

class DefaultRelayServiceTests: XCTestCase {

    // MARK: - Properties

    var graphQLClient: SudoApiClient!
    var instanceUnderTest: DefaultRelayService!
    var appSyncClientHelper: MockAppSyncClientHelper!
    var mockUserClient: MockSudoUserClient!
    var mockTransport: MockAWSNetworkTransport!
    var logger: Logger!

    let utcTimestamp: Double = 0.0

    // MARK: - Lifecycle

    override func setUp() {
        logger = Logger.testLogger

        guard let helper = try? MockAppSyncClientHelper() else {
            XCTFail("Cannot instantiate MockAppSyncClientHelper in \(#function)")
            return
        }
        appSyncClientHelper = helper
        self.mockUserClient = appSyncClientHelper.getMockUserClient()
        self.graphQLClient = appSyncClientHelper.getSudoApiClient()
        self.mockTransport = appSyncClientHelper.getMockTransport()

        instanceUnderTest = DefaultRelayService(sudoApiClient: graphQLClient, appSyncClientHelper: appSyncClientHelper)
        mockUserClient.isSignedInReturn = true
    }

    // MARK: - Tests: Lifecycle

    func test_initializer() {
        let service = DefaultRelayService(sudoApiClient: self.graphQLClient, appSyncClientHelper: self.appSyncClientHelper, logger: logger)
        XCTAssertTrue(service.sudoApiClient === graphQLClient)
        XCTAssertTrue(service.logger === logger)
    }

    // MARK: - Tests: listMessages

    func test_listMessages_RespectsErrors() async throws {
        self.mockTransport.error = AnyError("ERROR")
        do {
            _ = try await instanceUnderTest.listMessages(withConnectionId: "dummyId")
            XCTFail("Expected error not thrown.")
        } catch {
            self.XCTAssertErrorsEqual(error, SudoDIRelayError.fatalError(description: "Unexpected API operation error: appSyncClientError(cause: ERROR)"))
        }
    }

    func test_listMessages_ReturnsSuccessResult() async throws {

        var dummyGetMessagesData: [String: Any] {
            return [
                "__typename": "MessageEntry",
                "messageId": "dummyId",
                "connectionId": "dummyId",
                "cipherText": "dummyCipherText",
                "direction": "INBOUND",
                "utcTimestamp": utcTimestamp
            ]
        }

        var expectedResult: [RelayMessage] {
            return [
                RelayMessage(
                messageId: "dummyId",
                connectionId: "dummyId",
                cipherText: "dummyCipherText",
                direction: RelayMessage.Direction.inbound,
                timestamp: Date(millisecondsSince1970: 0)
            )
            ]
        }

        let queryData =  try GetMessagesQuery.Data(
            getMessages: [
                GetMessagesQuery.Data.GetMessage(jsonObject: dummyGetMessagesData)
            ]
        )

        self.mockTransport.responseBody = [
            [
                "data": queryData.jsonObject
            ]
        ]

        let messages = try await self.instanceUnderTest.listMessages(withConnectionId: "dummyId")
        XCTAssertEqual(messages, expectedResult)
    }

    // MARK: - Tests: StoreMessage

    func test_storeMessage_RespectsErrors() async throws {
        self.mockTransport.error = AnyError("Store Failed")

        do {
            _ = try await instanceUnderTest.storeMessage(withConnectionId: "dummyId", message: "message")
            XCTFail("Expected error not thrown.")
        } catch {
            self.XCTAssertErrorsEqual(
                error,
                SudoDIRelayError.fatalError(
                    description: "Unexpected API operation error: appSyncClientError(cause: Store Failed)")
            )
        }
    }

    func test_storeMessage_ReturnsSuccessResult() async {
        let data = StoreMessageMutation.Data.StoreMessage(
            messageId: "dummyId",
            connectionId: "dummyId",
            cipherText: "message",
            direction: Direction.inbound,
            utcTimestamp: utcTimestamp
        )
        let mutationData = StoreMessageMutation.Data(storeMessage: data)
        self.mockTransport.responseBody = [
            [
                "data": mutationData.jsonObject
            ]
        ]

        do {
            let message = try await instanceUnderTest.storeMessage(withConnectionId: "dummyId", message: "message")
            XCTAssertEqual(message?.connectionId, "dummyId")
            XCTAssertEqual(message?.messageId, "dummyId")
            XCTAssertEqual(message?.cipherText, "message")
            XCTAssertEqual(message?.timestamp, Date(millisecondsSince1970: 0))
            XCTAssertEqual(message?.direction, RelayMessage.Direction.inbound)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Tests: CreatePostbox

    func test_createPostbox_RespectsErrors() async {
        self.mockTransport.error = AnyError("Create Failed")

        do {
            _ = try await self.instanceUnderTest.createPostbox(withConnectionId: "dummyId", ownershipProofToken: "dummyProof")
            XCTFail("Expected error not thrown.")
        } catch {
            self.XCTAssertErrorsEqual(
                error,
                SudoDIRelayError.fatalError(description: "Unexpected API operation error: appSyncClientError(cause: Create Failed)")
            )
        }
    }

    func test_createPostbox_DoesNotThrowForSuccess() async {
        let data = SendInitMutation.Data.SendInit(connectionId: "dummyId", owner: "ownerId", utcTimestamp: utcTimestamp)
        let mutationData = SendInitMutation.Data(sendInit: data)
        self.mockTransport.responseBody = [
            [
                "data": mutationData.jsonObject
            ]
        ]
        do {
            try await instanceUnderTest.createPostbox(withConnectionId: "dummyId", ownershipProofToken: "dummyProof")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Tests: DeletePostbox

    func test_deletePostbox_RespectsErrors() async {
        self.mockTransport.error = AnyError("Delete Failed")

        do {
            _ = try await instanceUnderTest.deletePostbox(withConnectionId: "dummyId")
            XCTFail("Expected error not thrown.")
        } catch {
            self.XCTAssertErrorsEqual(
                error,
                SudoDIRelayError.fatalError(description: "Unexpected API operation error: appSyncClientError(cause: Delete Failed)")
            )
        }
    }

    func test_deletePostbox_DoesNotThrowForSuccess() async {

        let data = DeletePostBoxMutation.Data.DeletePostBox(status: 200)
        let mutationData = DeletePostBoxMutation.Data(deletePostBox: data)
        self.mockTransport.responseBody = [
            [
                "data": mutationData.jsonObject
            ]
        ]
        do {
            _ = try await instanceUnderTest.deletePostbox(withConnectionId: "dummyId")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Tests: GetPostboxEndpoint

    func test_getPostboxEndpoint_CorrectlyBuildsUrl() async {
        let result = instanceUnderTest.getPostboxEndpoint(withConnectionId: "id")
        guard let expected = URL(string: "test.com/id") else {
            XCTFail("Unable to set up test for \(#function)")
            return
        }
        XCTAssertEqual(expected, result)
    }

    // MARK: - Tests: listPostboxes

    func test_listPostboxes_RespectsErrors() async throws {
        self.mockTransport.error = AnyError("List Failed")

        do {
            _ = try await instanceUnderTest.listPostboxes(withSudoId: "dummyId")
            XCTFail("Expected error not thrown.")
        } catch {
            self.XCTAssertErrorsEqual(error, SudoDIRelayError.fatalError(description: "Unexpected API operation error: appSyncClientError(cause: List Failed)"))
        }
    }

    func test_listPostboxes_ReturnsSuccessResult() async {
        let data = ListPostboxesForSudoIdQuery.Data.ListPostboxesForSudoId(
            connectionId: "dummyId",
            sudoId: "sudoId",
            owner: "ownerId",
            utcTimestamp: utcTimestamp
        )
        let queryData = ListPostboxesForSudoIdQuery.Data(listPostboxesForSudoId: [data])
        self.mockTransport.responseBody = [
            [
                "data": queryData.jsonObject
            ]
        ]

        do {
            let postboxList = try await instanceUnderTest.listPostboxes(withSudoId: "sudoId")
            XCTAssertEqual(postboxList.count, 1)
            XCTAssertEqual(postboxList[0].connectionId, "dummyId")
            XCTAssertEqual(postboxList[0].sudoId, "sudoId")
            XCTAssertEqual(postboxList[0].userId, "ownerId")
            XCTAssertEqual(postboxList[0].timestamp, Date(millisecondsSince1970: 0))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

}
