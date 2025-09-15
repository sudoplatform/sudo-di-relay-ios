//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SudoApiClient
@testable import SudoDIRelay
import XCTest

struct UnusedGraphQLSelectionSet: GraphQLSelectionSet {
    static var selections: [GraphQLSelection] = []
    var snapshot: Snapshot = [:]

    init() {}

    init(snapshot: Snapshot) {
        // no op
    }
}

class UnusedQuery: GraphQLQuery {
    static var operationString: String = "unused"
    typealias Data = UnusedGraphQLSelectionSet
}

class UnusedMutation: GraphQLMutation {
    static var operationString: String = "unused"
    typealias Data = UnusedGraphQLSelectionSet
}

class UnusedSubscription: GraphQLSubscription {
    static var operationString: String = "unused"
    typealias Data = UnusedGraphQLSelectionSet
}
