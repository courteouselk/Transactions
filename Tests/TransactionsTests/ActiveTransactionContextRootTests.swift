//
//  ActiveTransactionContextRootTests.swift
//  Transactions
//
//  Created by Anton Bronnikov on 28/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import XCTest
import Transactions

class ActiveTransactionContextRootTests : ActiveTransactionContextTests {

    // MARK: - Begin transaction

    func test_BeginTransaction_Throws() {
        XCTAssertThrowsError(try self.library.beginTransaction()) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.anotherTransactionIsActive)
        }
    }

    // MARK: - Commit transaction

    func test_CommitTransaction_WithWildcardDescriptor_DoesNotThrow() {
        do {
            try library.commitTransaction()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_CommitTransaction_WithWildcardDescriptor_OnNoncommittable_Throws() {
        bookA.setCommittabilityError(LibraryError.someError)

        XCTAssertThrowsError(try self.library.commitTransaction()) {
            guard let error = $0 as? LibraryError else {
                XCTFail("Must throw LibraryError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, LibraryError.someError)
        }
    }

    func test_CommitTransaction_WithWildcardDescriptor_OnNoncommittable_DoesNotTriggerTransactable() {
        bookB.setCommittabilityError(LibraryError.someError)

        do { try library.commitTransaction(noncurrentTransaction) } catch { }

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

    func test_CommitTransaction_WithCurrentDescriptor_DoesNotThrow() {
        do {
            try library.commitTransaction(currentTransaction)
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_CommitTransaction_WithCurrentDescriptor_OnNoncommittable_Throws() {
        bookA.setCommittabilityError(LibraryError.someError)

        XCTAssertThrowsError(try self.library.commitTransaction(currentTransaction)) {
            guard let error = $0 as? LibraryError else {
                XCTFail("Must throw LibraryError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, LibraryError.someError)
        }
    }

    func test_CommitTransaction_WithCurrentDescriptor_OnNoncommittable_DoesNotTriggerTransactable() {
        bookB.setCommittabilityError(LibraryError.someError)

        do { try library.commitTransaction(currentTransaction) } catch { }

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(bookB.validationsCount, 1)

        XCTAssertEqual(bookB.failedValidationsCount, 1)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

    func test_CommitTransaction_WithNoncurrentDescriptor_Throws() {
        XCTAssertThrowsError(try self.library.commitTransaction(noncurrentTransaction)) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.wrongTransactionDescriptor)
        }
    }

    func test_CommitTransaction_WithNoncurrentDescriptor_DoesNotTriggerTransactable() {
        do { try library.commitTransaction(noncurrentTransaction) } catch { }

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

    // MARK: -

    func test_CommitTransaction_WithWildcardDescriptor_SetsContextStateInactive() {
        try! library.commitTransaction()

        XCTAssertFalse(library.transactionIsActive)
        XCTAssertFalse(bookA.transactionIsActive)
        XCTAssertFalse(bookB.transactionIsActive)
    }

    func test_CommitTransaction_WithWildcardDescriptor_SetsContextTransactionNil() {
        try! library.commitTransaction()

        XCTAssertNil(library.transactionContext.activeTransaction)
        XCTAssertNil(bookA.transactionContext.activeTransaction)
        XCTAssertNil(bookB.transactionContext.activeTransaction)
    }
    
    func test_CommitTransaction_WithWildcardDescriptor_TriggersTransactablesOnCommitOnly() {
        try! library.commitTransaction()

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

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
    }

    // MARK: -

    func test_CommitTransaction_WithCurrentDescriptor_SetsContextStateInactive() {
        try! library.commitTransaction(currentTransaction)

        XCTAssertFalse(library.transactionIsActive)
        XCTAssertFalse(bookA.transactionIsActive)
        XCTAssertFalse(bookB.transactionIsActive)
    }

    func test_CommitTransaction_WithCurrentDescriptor_SetsContextTransactionNil() {
        try! library.commitTransaction(currentTransaction)

        XCTAssertNil(library.transactionContext.activeTransaction)
        XCTAssertNil(bookA.transactionContext.activeTransaction)
        XCTAssertNil(bookB.transactionContext.activeTransaction)
    }

    func test_CommitTransaction_WithCurrentDescriptor_TriggersTransactablesOnCommitOnly() {
        try! library.commitTransaction(currentTransaction)

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

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
    }

    // MARK: - Rollback transaction

    func test_RollbackTransaction_WithWildcardDescriptor_DoesNotThrow() {
        do {
            try library.rollbackTransaction()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_RollbackTransaction_WithCurrentDescriptor_DoesNotThrow() {
        do {
            try library.rollbackTransaction(currentTransaction)
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }
    
    func test_RollbackTransaction_WithNoncurrentDescriptor_Throws() {
        XCTAssertThrowsError(try self.library.rollbackTransaction(noncurrentTransaction)) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.wrongTransactionDescriptor)
        }
    }

    func test_RollbackTransaction_WithNoncurrentDescriptor_DoesNotTriggerTransactable() {
        do { try library.rollbackTransaction(noncurrentTransaction) } catch { }

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

    // MARK: -

    func test_RollbackTransaction_WithWildcardDescriptor_SetsContextStateInactive() {
        try! library.rollbackTransaction()

        XCTAssertFalse(library.transactionIsActive)
        XCTAssertFalse(bookA.transactionIsActive)
        XCTAssertFalse(bookB.transactionIsActive)
    }

    func test_RollbackTransaction_WithWildcardDescriptor_SetsContextTransactionNil() {
        try! library.rollbackTransaction()

        XCTAssertNil(library.transactionContext.activeTransaction)
        XCTAssertNil(bookA.transactionContext.activeTransaction)
        XCTAssertNil(bookB.transactionContext.activeTransaction)
    }
    
    func test_RollbackTransaction_WithWildcardDescriptor_TriggersTransactablesOnRollbackOnly() {
        try! library.rollbackTransaction()

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

        XCTAssertEqual(library.rollbackCount, 1)
        XCTAssertEqual(bookA.rollbackCount, 1)
        XCTAssertEqual(bookB.rollbackCount, 1)
    }
    
    // MARK: -

    func test_RollbackTransaction_WithCurrentDescriptor_SetsContextStateInactive() {
        try! library.rollbackTransaction(currentTransaction)

        XCTAssertFalse(library.transactionIsActive)
        XCTAssertFalse(bookA.transactionIsActive)
        XCTAssertFalse(bookB.transactionIsActive)
    }

    func test_RollbackTransaction_WithCurrentDescriptor_SetsContextTransactionNil() {
        try! library.rollbackTransaction(currentTransaction)

        XCTAssertNil(library.transactionContext.activeTransaction)
        XCTAssertNil(bookA.transactionContext.activeTransaction)
        XCTAssertNil(bookB.transactionContext.activeTransaction)
    }

    func test_RollbackTransaction_WithCurrentDescriptor_TriggersTransactablesOnRollbackOnly() {
        try! library.rollbackTransaction(currentTransaction)

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

        XCTAssertEqual(library.rollbackCount, 1)
        XCTAssertEqual(bookA.rollbackCount, 1)
        XCTAssertEqual(bookB.rollbackCount, 1)
    }

    // MARK: - Transaction closure

    func test_SuccesfulTransactionClosure_DoesNotThrow() {
        do {
            try library.doTransactionClosure()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_SuccesfulTransactionClosure_DoesNotChangeTransactionStatus() {
        try! library.doTransactionClosure()

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

    func test_SuccesfulNestingTransactionClosures_DoNotChangeTransactionStatus() {
        try! library.doNestingTranscationClosure()

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

    func test_FailingTransactionClosure_DoesNotChangeTransactionStatus() {
        do { try library.doTransactionClosureThatThrows() } catch { }

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

    func test_FailingNestingTransactionClosure_DoNotChangeTransactionStatus() {
        do { try library.doNestingTranscationClosureThatThrows() } catch { }

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

        XCTAssertEqual(library.transactionClosureCount, 0)
        XCTAssertEqual(bookA.transactionClosureCount, 0)
        XCTAssertEqual(bookB.transactionClosureCount, 0)
    }

}
