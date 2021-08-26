enum PurchasesErrorCode {
  UnknownError,
  PurchaseCancelledError,
  StoreProblemError,
  PurchaseNotAllowedError,
  PurchaseInvalidError,
  ProductNotAvailableForPurchaseError,
  ProductAlreadyPurchasedError,
  ReceiptAlreadyInUseError,
  InvalidReceiptError,
  MissingReceiptFileError,
  NetworkError,
  InvalidCredentialsError,
  UnexpectedBackendResponseError,
  ReceiptInUseByOtherSubscriberError,
  InvalidAppUserIdError,
  OperationAlreadyInProgressError,
  UnknownBackendError,
  InsufficientPermissionsError
}