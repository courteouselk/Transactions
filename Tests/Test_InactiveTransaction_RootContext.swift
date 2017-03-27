//
//  Test_InactiveTransaction_RootContext.swift
//  Transactions
//
//  Created by Anton Bronnikov on 28/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import XCTest
import Transactions

class Test_InactiveTransaction_RootContext : Test_InactiveTransaction {

    // MARK: - Begin transaction

    func test_BeginTransaction_DoesNotThrow() {
        do {
            try library.transactionContext.beginTransaction()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_BeginTransaction_SetsContextStateActive() {
        try! library.transactionContext.beginTransaction()

        XCTAssertTrue(library.transactionContext.isActive)
        XCTAssertTrue(bookA.transactionContext.isActive)
        XCTAssertTrue(bookB.transactionContext.isActive)
    }

    func test_BeginTransaction_SetsContextTransactionConsistently() {
        let transaction = try! library.transactionContext.beginTransaction()

        XCTAssertEqual(library.transactionContext.transaction, transaction)
        XCTAssertEqual(bookA.transactionContext.transaction, transaction)
        XCTAssertEqual(bookB.transactionContext.transaction, transaction)
    }

    func test_BeginTransaction_TriggersTransactablesOnBeginOnly() {
        try! library.transactionContext.beginTransaction()

        XCTAssertEqual(library.beginCount, 1)
        XCTAssertEqual(bookA.beginCount, 1)
        XCTAssertEqual(bookB.beginCount, 1)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

    // MARK: - Commit transaction

    func test_CommitTransaction_Throws() {
        XCTAssertThrowsError(try self.library.transactionContext.commitTransaction()) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.transactionIsNotActive)
        }
    }

    func test_CommitTransaction_DoesNotTriggerTransactable() {
        do { try library.transactionContext.commitTransaction() } catch { }

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

    // MARK: - Rollback transaction

    func test_RollbackTransaction_Throws() {
        XCTAssertThrowsError(try self.library.transactionContext.rollbackTransaction()) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.transactionIsNotActive)
        }
    }

    func test_RollbackTransaction_DoesNotTriggerTransactable() {
        do { try library.transactionContext.rollbackTransaction() } catch { }

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

}
