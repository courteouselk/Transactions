//
//  InactiveTransactionContextRootTests.swift
//  Transactions
//
//  Created by Anton Bronnikov on 28/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import XCTest
import Transactions

class InactiveTransactionContextRootTests : InactiveTransactionContextTests {

    // MARK: - Begin transaction

    func test_BeginTransaction_DoesNotThrow() {
        do {
            try library.beginTransaction()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_BeginTransaction_SetsContextStateActive() {
        try! library.beginTransaction()

        XCTAssertTrue(library.transactionIsActive)
        XCTAssertTrue(bookA.transactionIsActive)
        XCTAssertTrue(bookB.transactionIsActive)
    }

    func test_BeginTransaction_SetsContextTransactionConsistently() {
        let transaction = try! library.beginTransaction()

        XCTAssertEqual(library.transactionContext.activeTransaction, transaction)
        XCTAssertEqual(bookA.transactionContext.activeTransaction, transaction)
        XCTAssertEqual(bookB.transactionContext.activeTransaction, transaction)
    }

    func test_BeginTransaction_TriggersTransactablesOnBeginOnly() {
        try! library.beginTransaction()

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
        XCTAssertThrowsError(try self.library.commitTransaction()) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.transactionIsNotActive)
        }
    }

    func test_CommitTransaction_DoesNotTriggerTransactable() {
        do { try library.commitTransaction() } catch { }

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
        XCTAssertThrowsError(try self.library.rollbackTransaction()) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.transactionIsNotActive)
        }
    }

    func test_RollbackTransaction_DoesNotTriggerTransactable() {
        do { try library.rollbackTransaction() } catch { }

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
            try library.doTransactionClosure()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_SuccesfulTransactionClosure_BeginsAndCommitsTransaction() {
        try! library.doTransactionClosure()

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

        XCTAssertEqual(library.transactionClosureCount, 1)
        XCTAssertEqual(bookA.transactionClosureCount, 0)
        XCTAssertEqual(bookB.transactionClosureCount, 0)
    }

    func test_SuccesfulNestingTransactionClosures_DoNotThrow() {
        do {
            try library.doNestingTranscationClosure()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_SuccesfulNestingTransactionClosures_BeginAndCommitTransaction() {
        try! library.doNestingTranscationClosure()

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

        XCTAssertEqual(library.transactionClosureCount, 1)
        XCTAssertEqual(bookA.transactionClosureCount, 0)
        XCTAssertEqual(bookB.transactionClosureCount, 0)
    }

    // MARK: -

    func test_FailingTransactionClosure_Throws() {
        XCTAssertThrowsError(try self.library.doTransactionClosureThatThrows()) {
            guard let error = $0 as? LibraryError else {
                XCTFail("Must throw LibraryError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, LibraryError.someError)
        }
    }

    func test_FailingTransactionClosure_BeginsAndRollsbackTransaction() {
        do { try library.doTransactionClosureThatThrows() } catch { }

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

    func test_FailingNestingTransactionClosure_Throws() {
        XCTAssertThrowsError(try self.library.doNestingTranscationClosureThatThrows()) {
            guard let error = $0 as? LibraryError else {
                XCTFail("Must throw LibraryError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, LibraryError.someError)
        }
    }

    func test_FailingNestingTransactionClosure_BeginsAndRollsbackTransaction() {
        do { try library.doNestingTranscationClosureThatThrows() } catch { }

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
        library.setCommittabilityError(LibraryError.someError)
        XCTAssertThrowsError(try self.library.doTransactionClosure()) {
            guard let error = $0 as? LibraryError else {
                XCTFail("Must throw LibraryError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, LibraryError.someError)
        }
    }

    func test_InvalidatedTransactionClosure_BeginsAndRollsbackTransaction() {
        library.setCommittabilityError(LibraryError.someError)

        do { try library.doTransactionClosure() } catch { }

        XCTAssertEqual(library.beginCount, 1)
        XCTAssertEqual(bookA.beginCount, 1)
        XCTAssertEqual(bookB.beginCount, 1)

        XCTAssertEqual(library.validationsCount, 1)

        XCTAssertEqual(library.failedValidationsCount, 1)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 1)
        XCTAssertEqual(bookA.rollbackCount, 1)
        XCTAssertEqual(bookB.rollbackCount, 1)
    }

    func test_InvalidatedNestingTransactionClosure_Throws() {
        library.setCommittabilityError(LibraryError.someError)
        XCTAssertThrowsError(try self.library.doNestingTranscationClosure()) {
            guard let error = $0 as? LibraryError else {
                XCTFail("Must throw LibraryError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, LibraryError.someError)
        }
    }

    func test_InvalidatedNestingTransactionClosure_BeginsAndRollsbackTransaction() {
        library.setCommittabilityError(LibraryError.someError)

        do { try library.doNestingTranscationClosure() } catch { }

        XCTAssertEqual(library.beginCount, 1)
        XCTAssertEqual(bookA.beginCount, 1)
        XCTAssertEqual(bookB.beginCount, 1)

        XCTAssertEqual(library.validationsCount, 1)

        XCTAssertEqual(library.failedValidationsCount, 1)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 1)
        XCTAssertEqual(bookA.rollbackCount, 1)
        XCTAssertEqual(bookB.rollbackCount, 1)
    }

}
