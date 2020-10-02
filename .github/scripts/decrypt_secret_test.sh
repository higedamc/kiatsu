#!/bin/sh
set -eo pipefail
sudo gpgconf --kill dirmngr
mkdir -p $HOME/.gnupg/
printf "$GPG_SIGNING_KEY" | base64 --decode > $HOME/.gnupg/private.key
gpg --import $HOME/.gnupg/private.key
# printenv | grep $SECRETS_PASSPHRASE
# gpg --quiet --batch --yes --passphrase="$SECRETS_PASSPHRASE" --output lib/env/production_secrets.dart --decrypt lib/env/production_secrets.dart.gpg
echo $SECRETS_PASSPHRASE | gpg --passphrase-fd 0 --output lib/env/production_secrets.dart --decrypt --batch lib/env/production_secrets.dart.gpg
echo $SECRETS_PASSPHRASE | gpg --passphrase-fd 0 --output ios/Runner/GoogleService-Info.plist --decrypt --batch ios/Runner/GoogleService-Info.plist.gpg