import 'package:wiredash/assets/l10n/wiredash_localizations.g.dart';

// TODO(Kohei): Do this later https://github.com/wiredashio/wiredash-sdk/blob/stable/lib/assets/l10n/wiredash_localizations_en.g.dart
class WiredashLocalizationsJapanese extends WiredashLocalizations {
  WiredashLocalizationsJapanese([String locale = 'ja']) : super(locale);

  @override
  String get backdropReturnToApp => 'アプリに戻る';

  @override
  String get feedbackBackButton => '戻る';

  @override
  String get feedbackCloseButton => '閉じる';

  @override
  String get feedbackDiscardButton => 'フィードバックを中止';

  @override
  String get feedbackDiscardConfirmButton => '本当に中止しますか？';

  @override
  String get feedbackNextButton => '進む';

  @override
  String get feedbackStep1MessageBreadcrumbTitle => 'メッセージを作成する';

  @override
  String get feedbackStep1MessageDescription => '遭遇した問題を説明してください。';

  @override
  String get feedbackStep1MessageErrorMissingMessage => 'メッセージを追加してください';

  @override
  // TODO: implement feedbackStep1MessageHint
  String get feedbackStep1MessageHint => '';

  @override
  String get feedbackStep1MessageTitle => 'フィードバックを残す';

  @override
  String get feedbackStep2LabelsBreadcrumbTitle => 'ラベル';

  @override
  // TODO: implement feedbackStep2LabelsDescription
  String get feedbackStep2LabelsDescription => '';

  @override
  // TODO: implement feedbackStep2LabelsTitle
  String get feedbackStep2LabelsTitle => '';

  @override
  String get feedbackStep3GalleryBreadcrumbTitle => 'スクリーンショット';

  @override
  // TODO: implement feedbackStep3GalleryDescription
  String get feedbackStep3GalleryDescription => '';

  @override
  // TODO: implement feedbackStep3GalleryTitle
  String get feedbackStep3GalleryTitle => '';

  @override
  // TODO: implement feedbackStep3ScreenshotBarCaptureButton
  String get feedbackStep3ScreenshotBarCaptureButton => '';

  @override
  // TODO: implement feedbackStep3ScreenshotBarDrawTitle
  String get feedbackStep3ScreenshotBarDrawTitle => '';

  @override
  String get feedbackStep3ScreenshotBarDrawUndoButton => '元に戻す';

  @override
  // TODO: implement feedbackStep3ScreenshotBarNavigateTitle
  String get feedbackStep3ScreenshotBarNavigateTitle => '';

  @override
  String get feedbackStep3ScreenshotBarOkButton => 'OK';

  @override
  String get feedbackStep3ScreenshotBarSaveButton => '保存';

  @override
  String get feedbackStep3ScreenshotOverviewAddScreenshotButton =>
      'スクリーンショットを追加';

  @override
  // TODO: implement feedbackStep3ScreenshotOverviewBreadcrumbTitle
  String get feedbackStep3ScreenshotOverviewBreadcrumbTitle => '';

  @override
  // TODO: implement feedbackStep3ScreenshotOverviewDescription
  String get feedbackStep3ScreenshotOverviewDescription => '';

  @override
  // TODO: implement feedbackStep3ScreenshotOverviewSkipButton
  String get feedbackStep3ScreenshotOverviewSkipButton => '';

  @override
  // TODO: implement feedbackStep3ScreenshotOverviewTitle
  String get feedbackStep3ScreenshotOverviewTitle => '';

  @override
  String get feedbackStep4EmailBreadcrumbTitle => '連絡先';

  @override
  // TODO: implement feedbackStep4EmailDescription
  String get feedbackStep4EmailDescription => '';

  @override
  // TODO: implement feedbackStep4EmailInputHint
  String get feedbackStep4EmailInputHint => '';

  @override
  // TODO: implement feedbackStep4EmailInvalidEmail
  String get feedbackStep4EmailInvalidEmail => '';

  @override
  // TODO: implement feedbackStep4EmailTitle
  String get feedbackStep4EmailTitle => '';

  @override
  // TODO: implement feedbackStep6SubmitBreadcrumbTitle
  String get feedbackStep6SubmitBreadcrumbTitle => '';

  @override
  // TODO: implement feedbackStep6SubmitDescription
  String get feedbackStep6SubmitDescription => '';

  @override
  // TODO: implement feedbackStep6SubmitSubmitButton
  String get feedbackStep6SubmitSubmitButton => '';

  @override
  String get feedbackStep6SubmitSubmitDetailsTitle => '詳細をフィードバック';

  @override
  String get feedbackStep6SubmitSubmitHideDetailsButton => '詳細を非表示';

  @override
  String get feedbackStep6SubmitSubmitShowDetailsButton => '詳細を表示';

  @override
  // TODO: implement feedbackStep6SubmitTitle
  String get feedbackStep6SubmitTitle => '';

  @override
  // TODO: implement feedbackStep7SubmissionErrorMessage
  String get feedbackStep7SubmissionErrorMessage => '';

  @override
  // TODO: implement feedbackStep7SubmissionInFlightMessage
  String get feedbackStep7SubmissionInFlightMessage => '';

  @override
  // TODO: implement feedbackStep7SubmissionOpenErrorButton
  String get feedbackStep7SubmissionOpenErrorButton => '';

  @override
  // TODO: implement feedbackStep7SubmissionRetryButton
  String get feedbackStep7SubmissionRetryButton => '';

  @override
  // TODO: implement feedbackStep7SubmissionSuccessMessage
  String get feedbackStep7SubmissionSuccessMessage => '';

  @override
  String feedbackStepXOfY(int current, int total) {
    // TODO: implement feedbackStepXOfY
   return '';
  }

  @override
  String get promoterScoreBackButton => '戻る';

  @override
  String get promoterScoreNextButton => '次へ';

  @override
  // TODO: implement promoterScoreStep1Description
  String get promoterScoreStep1Description => '';

  @override
  // TODO: implement promoterScoreStep1Question
  String get promoterScoreStep1Question => '';

  @override
  String promoterScoreStep2MessageDescription(int rating) {
    // TODO: implement promoterScoreStep2MessageDescription
   return '';
  }

  @override
  // TODO: implement promoterScoreStep2MessageHint
  String get promoterScoreStep2MessageHint => '';

  @override
  // TODO: implement promoterScoreStep2MessageTitle
  String get promoterScoreStep2MessageTitle => '';

  @override
  // TODO: implement promoterScoreStep3ThanksMessageDetractors
  String get promoterScoreStep3ThanksMessageDetractors => '';

  @override
  // TODO: implement promoterScoreStep3ThanksMessagePassives
  String get promoterScoreStep3ThanksMessagePassives => '';

  @override
  // TODO: implement promoterScoreStep3ThanksMessagePromoters
  String get promoterScoreStep3ThanksMessagePromoters => '';

  @override
  String get promoterScoreSubmitButton => '提出する';
}
