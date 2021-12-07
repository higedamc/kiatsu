//TODO: はるのんのエラーハンドリングの記事参考にRevenueCatのエラーハンドリングをする

//参考URL: https://zenn.dev/harunonsystem/articles/flutter_firebase_auth_error_handling

enum PurchasesErrorCode {
  unknownError,
  purchaseCancelledError,
  storeProblemError,
  purchaseNotAllowedError,
  purchaseInvalidError,
  productNotAvailableForPurchaseError,
  productAlreadyPurchasedError,
  receiptAlreadyInUseError,
  invalidReceiptError,
  missingReceiptFileError,
  networkError,
  invalidCredentialsError,
  unexpectedBackendResponseError,
  receiptInUseByOtherSubscriberError,
  invalidAppUserIdError,
  operationAlreadyInProgressError,
  unknownBackendError,
  insufficientPermissionsError
}