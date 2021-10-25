//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoOperations
@testable import SudoDIRelay

class MockPlatformOperationQueue: PlatformOperationQueue {

    override var operationCount: Int {
        return operationsAdded.count
    }

    override var operations: [Operation] {
        return operationsAdded
    }

    var operationsAdded: [Operation] = []

    override func addOperation(_ op: Operation) {
        operationsAdded.append(op)
    }

    override func addOperation(_ block: @escaping () -> Void) {
        operationsAdded.append(BlockOperation(block: block))
    }

    override func addOperations(_ ops: [Operation], waitUntilFinished wait: Bool) {
        operationsAdded.append(contentsOf: ops)
    }

    var cancelAllOperationsCallCount = 0

    override func cancelAllOperations() {
        cancelAllOperationsCallCount += 1
    }
}
