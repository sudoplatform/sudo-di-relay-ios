//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest

extension XCTestCase {

    private static let defaultTimeout = 1.0

    func waitUntil(
        file: StaticString = #file,
        line: UInt = #line,
        _ waitOn: @escaping (@escaping () -> Void) -> Void
    ) {
        waitUntil(file: file, line: line, timeout: XCTestCase.defaultTimeout, waitOn)
    }

    func waitUntil(
        file: StaticString = #file,
        line: UInt = #line,
        timeout: TimeInterval,
        _ waitOn: @escaping (@escaping () -> Void) -> Void
    ) {
        let waiter = XCTWaiter()
        let expectation = XCTestExpectation()
        waitOn {
            expectation.fulfill()
        }
        let result = waiter.wait(for: [expectation], timeout: timeout)
        switch result {
        case .timedOut:
            XCTFail("Asynchronous wait failed: Exceeded timeout of \(timeout) seconds", file: file, line: line)
        default:
            break
        }
    }

    /// Will create an expectation and fulfill it within a `DispatchQueue.main.async {}` call
    ///
    /// - Parameters:
    ///   - duration: The duration to wait before continuing
    ///   - completion: Optional handler for when the expectation has completed. This will contain a result enum.
    /// - Returns: `XCTWaiter.Result`
    @discardableResult
    public func waitForAsync(_ completion: ((XCTWaiter.Result) -> Void)? = nil) -> XCTWaiter.Result {
        let expectation = self.expectation(description: UUID().uuidString)
        DispatchQueue.main.async { expectation.fulfill() }
        return XCTWaiter.wait(for: [expectation], timeout: 2, enforceOrder: true)
    }

    /// Compare two errors.
    /// - Parameters:
    ///   - lhs: first error.
    ///   - rhs: second error.
    ///   - file: file reference.
    ///   - line: line reference.
    func XCTAssertErrorsEqual(_ lhs: Error?, _ rhs: Error?, file: StaticString = #file, line: UInt = #line) {
        if lhs == nil, rhs == nil {
            // No more testing is needed, they are equal
            return
        }
        guard let left = lhs else {
            return XCTFail("\(String(describing: lhs)) does not match \(String(describing: rhs))", file: file, line: line)
        }
        guard let right = rhs else {
            return XCTFail("\(String(describing: lhs)) does not match \(String(describing: rhs))", file: file, line: line)
        }

        XCTAssertTrue(areEqual(left, right), "\(String(describing: lhs)) does not match \(String(describing: rhs))", file: file, line: line)
    }
}
