//
//  Transactable.swift
//  Transactions
//
//  Created by Anton Bronnikov on 23/03/2017.
//  Copyright © 2017 Anton Bronnikov. All rights reserved.
//

/// Transaction-aware object.
///
/// Conforming object change their state as a part of transaction.  Each individual transaction 
/// will encapsulate changes to all of the objects and only commit if all of them report
/// consistency.

public protocol Transactable : AnyObject {

    /// Transaction context owned by a transactable.

    var transactionContext: TransactionContext { get }

    /// Indicates whether a transactable is in committable (i.e. consistent) state.

    func isCommittable() -> Bool

    // MARK: - Transaction management

    /// Transaction begin handler.
    /// 
    /// This method is called at the beginning of each transaction to allow the transactable object
    /// make necessary preparations before the transaction starts.

    func onBegin(transaction: Transaction)

    /// Transaction commit handler.
    ///
    /// This method is called when the transaction commit is requested.

    func onCommit(transaction: Transaction)

    /// Transaction rollback handler.
    ///
    /// This method is called when the transaction rollback is requested.

    func onRollback(transaction: Transaction)
    
}
