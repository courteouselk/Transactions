//
//  Test_ActiveTransaction_RootContext.swift
//  Transactions
//
//  Created by Anton Bronnikov on 28/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

import XCTest
import Transactions

class Test_ActiveTransaction_RootContext : Test_ActiveTransaction {

    // MARK: - Begin transaction

    func test_BeginTransaction_Throws() {
        XCTAssertThrowsError(try self.library.transactionContext.beginTransaction()) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.anotherTransactionIsStillActive)
        }
    }

    // MARK: - Commit transaction

    func test_CommitTransaction_WithWildcardDescriptor_DoesNotThrow() {
        do {
            try library.transactionContext.commitTransaction()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_CommitTransaction_WithWildcardDescriptor_OnNoncommittable_Throws() {
        bookA.setCommittable(false)

        XCTAssertThrowsError(try self.library.transactionContext.commitTransaction()) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.uncommittableTransaction)
        }
    }

    func test_CommitTransaction_WithWildcardDescriptor_OnNoncommittable_DoesNotTriggerTransactable() {
        bookB.setCommittable(false)

        do { try library.transactionContext.commitTransaction(noncurrentTransaction) } catch { }

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

    func test_CommitTransaction_WithCurrentDescriptor_DoesNotThrow() {
        do {
            try library.transactionContext.commitTransaction(currentTransaction)
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_CommitTransaction_WithCurrentDescriptor_OnNoncommittable_Throws() {
        bookA.setCommittable(false)

        XCTAssertThrowsError(try self.library.transactionContext.commitTransaction(currentTransaction)) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.uncommittableTransaction)
        }
    }

    func test_CommitTransaction_WithCurrentDescriptor_OnNoncommittable_DoesNotTriggerTransactable() {
        bookB.setCommittable(false)

        do { try library.transactionContext.commitTransaction(currentTransaction) } catch { }

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

    func test_CommitTransaction_WithNoncurrentDescriptor_Throws() {
        XCTAssertThrowsError(try self.library.transactionContext.commitTransaction(noncurrentTransaction)) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.wrongTransactionDescriptor)
        }
    }

    func test_CommitTransaction_WithNoncurrentDescriptor_DoesNotTriggerTransactable() {
        do { try library.transactionContext.commitTransaction(noncurrentTransaction) } catch { }

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

    // MARK: -

    func test_CommitTransaction_WithWildcardDescriptor_SetsContextStateInactive() {
        try! library.transactionContext.commitTransaction()

        XCTAssertFalse(library.transactionContext.isActive)
        XCTAssertFalse(bookA.transactionContext.isActive)
        XCTAssertFalse(bookB.transactionContext.isActive)
    }

    func test_CommitTransaction_WithWildcardDescriptor_SetsContextTransactionNil() {
        try! library.transactionContext.commitTransaction()

        XCTAssertNil(library.transactionContext.transaction)
        XCTAssertNil(bookA.transactionContext.transaction)
        XCTAssertNil(bookB.transactionContext.transaction)
    }
    
    func test_CommitTransaction_WithWildcardDescriptor_TriggersTransactablesOnCommitOnly() {
        try! library.transactionContext.commitTransaction()

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.commitCount, 1)
        XCTAssertEqual(bookA.commitCount, 1)
        XCTAssertEqual(bookB.commitCount, 1)

        XCTAssertEqual(library.rollbackCount, 0)
        XCTAssertEqual(bookA.rollbackCount, 0)
        XCTAssertEqual(bookB.rollbackCount, 0)
    }

    // MARK: -

    func test_CommitTransaction_WithCurrentDescriptor_SetsContextStateInactive() {
        try! library.transactionContext.commitTransaction(currentTransaction)

        XCTAssertFalse(library.transactionContext.isActive)
        XCTAssertFalse(bookA.transactionContext.isActive)
        XCTAssertFalse(bookB.transactionContext.isActive)
    }

    func test_CommitTransaction_WithCurrentDescriptor_SetsContextTransactionNil() {
        try! library.transactionContext.commitTransaction(currentTransaction)

        XCTAssertNil(library.transactionContext.transaction)
        XCTAssertNil(bookA.transactionContext.transaction)
        XCTAssertNil(bookB.transactionContext.transaction)
    }

    func test_CommitTransaction_WithCurrentDescriptor_TriggersTransactablesOnCommitOnly() {
        try! library.transactionContext.commitTransaction(currentTransaction)

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

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
            try library.transactionContext.rollbackTransaction()
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }

    func test_RollbackTransaction_WithCurrentDescriptor_DoesNotThrow() {
        do {
            try library.transactionContext.rollbackTransaction(currentTransaction)
        } catch {
            XCTFail("Should not throw, but thrown \(error) instead")
        }
    }
    
    func test_RollbackTransaction_WithNoncurrentDescriptor_Throws() {
        XCTAssertThrowsError(try self.library.transactionContext.rollbackTransaction(noncurrentTransaction)) {
            guard let error = $0 as? TransactionError else {
                XCTFail("Must throw TransactionError, but thrown \(type(of: $0)) instead"); return
            }
            XCTAssertEqual(error, TransactionError.wrongTransactionDescriptor)
        }
    }

    func test_RollbackTransaction_WithNoncurrentDescriptor_DoesNotTriggerTransactable() {
        do { try library.transactionContext.rollbackTransaction(noncurrentTransaction) } catch { }

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

    // MARK: -

    func test_RollbackTransaction_WithWildcardDescriptor_SetsContextStateInactive() {
        try! library.transactionContext.rollbackTransaction()

        XCTAssertFalse(library.transactionContext.isActive)
        XCTAssertFalse(bookA.transactionContext.isActive)
        XCTAssertFalse(bookB.transactionContext.isActive)
    }

    func test_RollbackTransaction_WithWildcardDescriptor_SetsContextTransactionNil() {
        try! library.transactionContext.rollbackTransaction()

        XCTAssertNil(library.transactionContext.transaction)
        XCTAssertNil(bookA.transactionContext.transaction)
        XCTAssertNil(bookB.transactionContext.transaction)
    }
    
    func test_RollbackTransaction_WithWildcardDescriptor_TriggersTransactablesOnRollbackOnly() {
        try! library.transactionContext.rollbackTransaction()

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 1)
        XCTAssertEqual(bookA.rollbackCount, 1)
        XCTAssertEqual(bookB.rollbackCount, 1)
    }
    
    // MARK: -

    func test_RollbackTransaction_WithCurrentDescriptor_SetsContextStateInactive() {
        try! library.transactionContext.rollbackTransaction(currentTransaction)

        XCTAssertFalse(library.transactionContext.isActive)
        XCTAssertFalse(bookA.transactionContext.isActive)
        XCTAssertFalse(bookB.transactionContext.isActive)
    }

    func test_RollbackTransaction_WithCurrentDescriptor_SetsContextTransactionNil() {
        try! library.transactionContext.rollbackTransaction(currentTransaction)

        XCTAssertNil(library.transactionContext.transaction)
        XCTAssertNil(bookA.transactionContext.transaction)
        XCTAssertNil(bookB.transactionContext.transaction)
    }

    func test_RollbackTransaction_WithCurrentDescriptor_TriggersTransactablesOnRollbackOnly() {
        try! library.transactionContext.rollbackTransaction(currentTransaction)

        XCTAssertEqual(library.beginCount, 0)
        XCTAssertEqual(bookA.beginCount, 0)
        XCTAssertEqual(bookB.beginCount, 0)

        XCTAssertEqual(library.commitCount, 0)
        XCTAssertEqual(bookA.commitCount, 0)
        XCTAssertEqual(bookB.commitCount, 0)

        XCTAssertEqual(library.rollbackCount, 1)
        XCTAssertEqual(bookA.rollbackCount, 1)
        XCTAssertEqual(bookB.rollbackCount, 1)
    }

}
