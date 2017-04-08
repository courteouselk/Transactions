# Change Log

## [0.0.2](https://github.com/courteouselk/Transactions/compare/0.0.1...0.0.2) (unreleased)

### Changed API

- Renamed `Transactable.isCommittable()` to `onValidateCommit()` that  can throw `Error` if the 
  transaction is not good to commit. This allows transactable to be more specific about the 
  problem (i.e. why the transaction can not be committed).
- Renamed `TransactionContext.transaction` to `.activeTransaction`
- Renamed `TransactionContext.isActive` to `.transactionIsActive`

### Miscellaneous

- Improved documentation.

## [0.0.1](https://github.com/courteouselk/Transactions/releases/tag/0.0.1)

- Base functionality:
  - `Transactable`
  - `TransactionContext.createRoot(_)`
  - `TransactionContext.createNode(_, _)`
