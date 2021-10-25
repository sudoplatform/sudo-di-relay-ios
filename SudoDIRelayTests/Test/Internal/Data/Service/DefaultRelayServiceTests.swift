//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
import AWSAppSync
import SudoKeyManager
import SudoLogging
import SudoOperations
@testable import SudoDIRelay

class DefaultRelayServiceTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: DefaultRelayService!

    var mockOperationFactory: MockOperationFactory!
    var appSyncClient: AWSAppSyncClient!

    let utcTimestamp = "Thu, 1 Jan 1970 00:00:00 GMT+00"

    // MARK: - Lifecycle

    override func setUp() {
        mockOperationFactory = MockOperationFactory()
        appSyncClient = MockAWSAppSyncClientGenerator.generateClient()
        instanceUnderTest = DefaultRelayService(appSyncClient: appSyncClient)
        instanceUnderTest.operationFactory = mockOperationFactory
    }

    // MARK: - Tests: Lifecycle

    func test_initializer() {
        let logger = Logger.testLogger
        let instanceUnderTest = DefaultRelayService(appSyncClient: appSyncClient, logger: logger)
        XCTAssertTrue(instanceUnderTest.appSyncClient === appSyncClient)
        XCTAssertTrue(instanceUnderTest.logger === logger)
    }

    func test_reset() {
        let mockQueue = MockPlatformOperationQueue()
        instanceUnderTest.queue = mockQueue
        instanceUnderTest.reset()
        XCTAssertEqual(mockQueue.cancelAllOperationsCallCount, 1)
    }

    // MARK: - Tests: GetMessages

    func test_getMessages_ConstructsOperation() {
        instanceUnderTest.queue.isSuspended = true
        instanceUnderTest.getMessages(withConnectionId: "dummyId") { _ in }
        XCTAssertEqual(instanceUnderTest.queue.operationCount, 1)
        guard let operation = instanceUnderTest.queue.operations.first(whereType: PlatformQueryOperation<GetMessagesQuery>.self) else {
            return XCTFail("Expected operation not found")
        }
        XCTAssertEqual(operation.cachePolicy, .remoteOnly)
    }

    func test_getMessages_RespectsOperationFailure() {
        mockOperationFactory.getMessagesOperation = MockGetMessagesOperation(error: AnyError("Get Failed"))
        waitUntil { done in
            self.instanceUnderTest.getMessages(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case let .failure(error as AnyError):
                    XCTAssertEqual(error, AnyError("Get Failed"))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }

    func test_getMessages_ReturnsOperationSuccessResult() throws {
        let data = DataFactory.GraphQL.getMessages

        mockOperationFactory.getMessagesOperation = MockGetMessagesOperation(result: data)
        waitUntil { done in
            self.instanceUnderTest.getMessages(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case let .success(result):
                    XCTAssertEqual(result[0].connectionId, "dummyId")
                    XCTAssertEqual(result[0].messageId, "dummyId")
                    XCTAssertEqual(result[0].cipherText, "message")
                    XCTAssertEqual(result[0].direction, RelayMessage.Direction.inbound)
                    XCTAssertEqual(result[0].timestamp, Date(millisecondsSince1970: 0))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }

    // MARK: - Tests: StoreMessage

    func test_storeMessage_RespectsOperationFailure() {
        mockOperationFactory.storeMessageOperation = MockStoreMessageOperation(error: AnyError("Store Failed"))
        waitUntil { done in
            self.instanceUnderTest.storeMessage(withConnectionId: "dummyId", message: "message") { result in
                defer { done() }
                switch result {
                case let .failure(error as AnyError):
                    XCTAssertEqual(error, AnyError("Store Failed"))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }

    func test_storeMessage_ReturnsOperationSuccessResult() {
        let data = StoreMessageMutation.Data.StoreMessage(
            messageId: "dummyId",
            connectionId: "dummyId",
            cipherText: "message",
            direction: Direction.inbound,
            utcTimestamp: utcTimestamp
        )
        let result = StoreMessageMutation.Data(storeMessage: data)
        mockOperationFactory.storeMessageOperation = MockStoreMessageOperation(result: result)
        waitUntil { done in
            self.instanceUnderTest.storeMessage(withConnectionId: "dummyId", message: "message") { result in
                defer { done() }
                switch result {
                case .success(let message):
                    XCTAssertEqual(message?.connectionId, "dummyId")
                    XCTAssertEqual(message?.messageId, "dummyId")
                    XCTAssertEqual(message?.cipherText, "message")
                    XCTAssertEqual(message?.timestamp, Date(millisecondsSince1970: 0))
                    XCTAssertEqual(message?.direction, RelayMessage.Direction.inbound)
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }

    // MARK: - Tests: CreatePostbox

    func test_createPostbox_ConstructsOperation() {
        instanceUnderTest.queue.isSuspended = true
        XCTAssertEqual(instanceUnderTest.queue.operationCount, 0)
        self.instanceUnderTest.createPostbox(withConnectionId: "dummyId") { _ in }
        XCTAssertEqual(instanceUnderTest.queue.operationCount, 1)
        XCTAssertTrue(instanceUnderTest.queue.operations.contains(operationType: PlatformMutationOperation<SendInitMutation>.self))
    }

    func test_createPostbox_RespectsOperationFailure() {
        mockOperationFactory.createPostboxOperation = MockCreatePostboxOperation(error: AnyError("Create Failed"))
        waitUntil { done in
            self.instanceUnderTest.createPostbox(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case let .failure(error as SudoDIRelayError):
                    XCTAssertEqual(error, SudoDIRelayError.invalidInitMessage)
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }

    func test_createPostbox_ReturnsOperationSuccessResult() throws {
        let result = DataFactory.GraphQL.createPostbox
        mockOperationFactory.createPostboxOperation = MockCreatePostboxOperation(result: result)
        waitUntil { done in
            self.instanceUnderTest.createPostbox(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case .success():
                    break
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }

    // MARK: - Tests: DeletePostbox

    func test_deletePostbox_ConstructsOperation() {
        instanceUnderTest.queue.isSuspended = true
        XCTAssertEqual(instanceUnderTest.queue.operationCount, 0)
        self.instanceUnderTest.deletePostbox(withConnectionId: "dummyId") { _ in }
        XCTAssertEqual(instanceUnderTest.queue.operationCount, 1)
        XCTAssertTrue(instanceUnderTest.queue.operations.contains(operationType: PlatformMutationOperation<DeletePostBoxMutation>.self))
    }

    func test_deletePostbox_RespectsOperationFailure() {
        mockOperationFactory.deletePostboxOperation = MockDeletePostboxOperation(error: AnyError("Create Failed"))
        waitUntil { done in
            self.instanceUnderTest.deletePostbox(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case let .failure(error as AnyError):
                    XCTAssertEqual(error, AnyError("Create Failed"))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }

    func test_deletePostbox_ReturnsOperationSuccessResult() {
        let data = DataFactory.GraphQL.deletePostbox

        mockOperationFactory.deletePostboxOperation = MockDeletePostboxOperation(result: data)
        waitUntil { done in
            self.instanceUnderTest.deletePostbox(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case .success:
                    break
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }
}
