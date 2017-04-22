//
//  InactiveTransactionContextTests.swift
//  Transactions
//
//  Created by Anton Bronnikov on 24/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import XCTest
import Transactions

class InactiveTransactionContextTests : TransactionContextTests {

    // MARK: - Verify initial state

    final func test_InitialState_ContextsAreInactive() {
        XCTAssertFalse(library.transactionIsActive)
        XCTAssertFalse(bookA.transactionIsActive)
        XCTAssertFalse(bookB.transactionIsActive)
    }

    final func test_InitialState_ContextTransactionsAreNil() {
        XCTAssertNil(library.activeTransaction)
        XCTAssertNil(bookA.activeTransaction)
        XCTAssertNil(bookB.activeTransaction)
    }

}
