//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SudoLogging

internal extension Logger {

    /// Logger used internally in the SudoDIRelay.
    static let testLogger = Logger(identifier: "Test-SudoDIRelay", driver: NSLogDriver(level: .debug))
}
