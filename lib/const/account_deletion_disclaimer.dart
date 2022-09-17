import 'package:flutter/material.dart';

String encodedBody = Uri.encodeComponent('アカウント削除申請');
const myEmailAddress = 'kohei.otani@tutanota.com';

final params = Uri(
  scheme: 'mailto',
  path: 'kohei.otani@tutanota.com',
  // queryParameters: {
  //   'subject': 'アカウント削除申請',
  // },
);

const accountDeletionPromt = '''
本当に kiatsu アカウントを削除しますか？
削除される場合は、以下の内容を必ずご確認ください。''';

const accountDeletion = '''
kiatsu アカウントに紐づくデータはすべて削除されますが、データの容量によっては、瞬時に削除されない場合があります。
詳細は、別途、下記へお問合せください。''';

const subscriptionDeletion = '''
kiatsu アカウントに紐づくデータはすべて削除されますが、登録されている月間または年間サブスクリプション
は自動的に解除されません。必ずアカウント削除前にサブスクリプションを解除してください。
また、アカウント削除後にサブスクリプションを解除したい場合は、App を開く -> 自分の名前をタップ ->
 「サブスクリプション」をタップ -> 購読されているサブスクリプションの中にある「有効」セクションから kiatsu をタップして、サブスクリプションを解除してください。
''';

const accountDeletionConirmation = '''
上記に同意して kiatsu アカウントを削除する。''';

const accountDeletionFinalPrompt = '''
アカウントを削除すると全ての機能に今後アクセスできなくなります。
\n削除する場合、本人確認のため再度アカウントログインのポップアップが表示されます。''';

