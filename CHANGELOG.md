# Change Log

## Unreleased

### Changed API

- Refactored `Transactable.isCommittable()` into `onValidateCommit()` that  can throw `Error` in 
  if the transaction is not good to commit. This allows transactable to be more specific about the 
  problem (i.e. why the transaction can not be committed).

### Miscellaneous

- Improved documentation.

## [0.0.1](https://github.com/courteouselk/Transactions/releases/tag/0.0.1)

- Base functionality:
  - `Transactable`
  - `TransactionContext.createRoot(_)`
  - `TransactionContext.createNode(_, _)`
