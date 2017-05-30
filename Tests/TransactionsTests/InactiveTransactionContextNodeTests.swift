//
//  InactiveTransactionContextNodeTests.swift
//  Transactions
//
//  Created by Anton Bronnikov on 28/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import XCTest
import Transactions

class InactiveTransactionContextNodeTests : InactiveTransactionContextTests {

    // MARK: - Begin transaction

    func test_BeginTransaction_DoesNotThrow() {
        do {
            try bookA.beginTransaction()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_BeginTransaction_SetsContextStateActive() {
        try! bookB.beginTransaction()

        XCTAssertTrue(library.transactionIsActive)
        XCTAssertTrue(bookA.transactionIsActive)
        XCTAssertTrue(bookB.transactionIsActive)
    }

    func test_BeginTransaction_SetsContextTransactionConsistently() {
        let transaction = try! bookB.beginTransaction()

        XCTAssertEqual(library.transactionContext.activeTransaction, transaction)
        XCTAssertEqual(bookA.transactionContext.activeTransaction, transaction)
        XCTAssertEqual(bookB.transactionContext.activeTransaction, transaction)
    }

    func test_BeginTransaction_TriggersTransactablesOnBeginOnly() {
        try! bookA.beginTransaction()

        XCTAssertEqual(library.beginCount, 1)
        XCTAssertEqual(bookA.beginCount, 1)
        XCTAssertEqual(bookB.beginCount, 1)

        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

    // MARK: - Commit transaction

    func test_CommitTransaction_Throws() {
        XCTAssertThrowsError(try self.bookA.commitTransaction()) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.transactionIsNotActive)
        }
    }

    func test_CommitTransaction_DoesNotTriggerTransactable() {
        do { try bookB.commitTransaction() } catch { }

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

    // MARK: - Rollback transaction

    func test_RollbackTransaction_Throws() {
        XCTAssertThrowsError(try self.bookA.rollbackTransaction()) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.transactionIsNotActive)
        }
    }

    func test_RollbackTransaction_DoesNotTriggerTransactable() {
        do { try bookB.rollbackTransaction() } catch { }

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

    // MARK: - Transaction closure

    func test_SuccesfulTransactionClosure_DoesNotThrow() {
        do {
            try bookA.doTransactionClosure()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_SuccesfulTransactionClosure_BeginsAndCommitsTransaction() {
        try! bookB.doTransactionClosure()

        XCTAssertEqual(library.beginCount, 1)
        XCTAssertEqual(bookA.beginCount, 1)
        XCTAssertEqual(bookB.beginCount, 1)

        XCTAssertEqual(library.validationsCount, 1)
        XCTAssertEqual(bookA.validationsCount, 1)
        XCTAssertEqual(bookB.validationsCount, 1)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 1)
        XCTAssertEqual(bookA.commitCount, 1)
        XCTAssertEqual(bookB.commitCount, 1)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)

        XCTAssertEqual(library.transactionClosureCount, 0)
        XCTAssertEqual(bookA.transactionClosureCount, 0)
        XCTAssertEqual(bookB.transactionClosureCount, 1)
    }

    func test_SuccesfulNestingTransactionClosures_DoNotThrow() {
        do {
            try bookA.doNestingTranscationClosure()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_SuccesfulNestingTransactionClosures_BeginAndCommitTransaction() {
        try! bookB.doNestingTranscationClosure()

        XCTAssertEqual(library.beginCount, 1)
        XCTAssertEqual(bookA.beginCount, 1)
        XCTAssertEqual(bookB.beginCount, 1)

        XCTAssertEqual(library.validationsCount, 1)
        XCTAssertEqual(bookA.validationsCount, 1)
        XCTAssertEqual(bookB.validationsCount, 1)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 1)
        XCTAssertEqual(bookA.commitCount, 1)
        XCTAssertEqual(bookB.commitCount, 1)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)

        XCTAssertEqual(library.transactionClosureCount, 0)
        XCTAssertEqual(bookA.transactionClosureCount, 0)
        XCTAssertEqual(bookB.transactionClosureCount, 1)
    }

    // MARK: -

    func test_FailingTransactionClosure_Throws() {
        XCTAssertThrowsError(try self.bookA.doTransactionClosureThatThrows()) {
            guard let error = $0 as? LibraryError else {
                XCTFail("Must throw LibraryError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, LibraryError.someError)
        }
    }

    func test_FailingTransactionClosure_BeginsAndRollsbackTransaction() {
        do { try bookB.doTransactionClosureThatThrows() } catch { }

        XCTAssertEqual(library.beginCount, 1)
        XCTAssertEqual(bookA.beginCount, 1)
        XCTAssertEqual(bookB.beginCount, 1)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 1)
        XCTAssertEqual(bookA.rollbackCount, 1)
        XCTAssertEqual(bookB.rollbackCount, 1)

        XCTAssertEqual(library.transactionClosureCount, 0)
        XCTAssertEqual(bookA.transactionClosureCount, 0)
        XCTAssertEqual(bookB.transactionClosureCount, 0)
    }

    func test_FailingNestingTransactionClosure_Throws() {
        XCTAssertThrowsError(try self.bookA.doNestingTranscationClosureThatThrows()) {
            guard let error = $0 as? LibraryError else {
                XCTFail("Must throw LibraryError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, LibraryError.someError)
        }
    }

    func test_FailingNestingTransactionClosure_BeginsAndRollsbackTransaction() {
        do { try bookB.doNestingTranscationClosureThatThrows() } catch { }

        XCTAssertEqual(library.beginCount, 1)
        XCTAssertEqual(bookA.beginCount, 1)
        XCTAssertEqual(bookB.beginCount, 1)

        XCTAssertEqual(library.validationsCount, 0)
        XCTAssertEqual(bookA.validationsCount, 0)
        XCTAssertEqual(bookB.validationsCount, 0)

        XCTAssertEqual(library.failedValidationsCount, 0)
        XCTAssertEqual(bookA.failedValidationsCount, 0)
        XCTAssertEqual(bookB.failedValidationsCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 1)
        XCTAssertEqual(bookA.rollbackCount, 1)
        XCTAssertEqual(bookB.rollbackCount, 1)

        XCTAssertEqual(library.transactionClosureCount, 0)
        XCTAssertEqual(bookA.transactionClosureCount, 0)
        XCTAssertEqual(bookB.transactionClosureCount, 0)
    }

    // MARK: -

    func test_InvalidatedTransactionClosure_Throws() {
        bookA.setCommittabilityError(LibraryError.someError)
        XCTAssertThrowsError(try self.bookA.doTransactionClosure()) {
            guard let error = $0 as? LibraryError else {
                XCTFail("Must throw LibraryError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, LibraryError.someError)
        }
    }

    func test_InvalidatedTransactionClosure_BeginsAndRollsbackTransaction() {
        bookB.setCommittabilityError(LibraryError.someError)

        do { try bookB.doTransactionClosure() } catch { }

        XCTAssertEqual(library.beginCount, 1)
        XCTAssertEqual(bookA.beginCount, 1)
        XCTAssertEqual(bookB.beginCount, 1)

        XCTAssertEqual(bookB.validationsCount, 1)

        XCTAssertEqual(bookB.failedValidationsCount, 1)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 1)
        XCTAssertEqual(bookA.rollbackCount, 1)
        XCTAssertEqual(bookB.rollbackCount, 1)
    }

    func test_InvalidatedNestingTransactionClosure_Throws() {
        bookA.setCommittabilityError(LibraryError.someError)
        XCTAssertThrowsError(try self.bookA.doNestingTranscationClosure()) {
            guard let error = $0 as? LibraryError else {
                XCTFail("Must throw LibraryError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, LibraryError.someError)
        }
    }

    func test_InvalidatedNestingTransactionClosure_BeginsAndRollsbackTransaction() {
        bookB.setCommittabilityError(LibraryError.someError)

        do { try bookB.doNestingTranscationClosure() } catch { }

        XCTAssertEqual(library.beginCount, 1)
        XCTAssertEqual(bookA.beginCount, 1)
        XCTAssertEqual(bookB.beginCount, 1)

        XCTAssertEqual(bookB.validationsCount, 1)

        XCTAssertEqual(bookB.failedValidationsCount, 1)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 1)
        XCTAssertEqual(bookA.rollbackCount, 1)
        XCTAssertEqual(bookB.rollbackCount, 1)
    }

}
