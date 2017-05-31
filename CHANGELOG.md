# Change Log

## [0.0.5](https://github.com/courteouselk/Transactions/compare/0.0.4...0.0.5)

### Miscellanneous

- Repository housekeeping.

## [0.0.4](https://github.com/courteouselk/Transactions/compare/0.0.3...0.0.4)

### Miscellanneous

- Add Linux support.
- Add CocoaPods support.

## [0.0.3](https://github.com/courteouselk/Transactions/compare/0.0.2...0.0.3)

### Bug fixes

- If the body of `transaction` closure would fail `onValidateCommit` the rollback will now be 
  triggered.
- Default implementations (empty) for `onXXX` handlers could overshadow concrete implementations of
  the same handlers on protocol adopters.  These are removed now.

### Other

- Updated documentation.

## [0.0.2](https://github.com/courteouselk/Transactions/compare/0.0.1...0.0.2)

### New API

- Methods declared on `Transactable` can now use `try transaction { \* do stuff *\ }` construct.

### Changed API

- Renamed `Transactable.isCommittable()` to `onValidateCommit()` that  can throw `Error` if the
  transaction is not good to commit. This allows transactable to be more specific about the
  problem (i.e. why the transaction can not be committed).
- Renamed `TransactionContext.transaction` to `.activeTransaction`
- Renamed `TransactionContext.isActive` to `.transactionIsActive`

### Fixes

- Transaction context node now triggers relevan `onBegin` handlers in case if it is being added into
  the context tree in the middle of an active transaction.

### Miscellaneous

- Improved documentation.

## [0.0.1](https://github.com/courteouselk/Transactions/releases/tag/0.0.1)

- Base functionality:
  - `Transactable`
  - `TransactionContext.createRoot(_)`
  - `TransactionContext.createNode(_, _)`
