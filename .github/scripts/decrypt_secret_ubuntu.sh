#!/bin/sh
sudo gpgconf --kill dirmngr
mkdir -p $HOME/secrets
mkdir -p $HOME/.gnupg/
printf "$GPG_SIGNING_KEY" | base64 --decode > $HOME/.gnupg/private.key
gpg --import $HOME/.gnupg/private.key
echo $SECRETS_PASSPHRASE | gpg --passphrase-fd 0 --output lib/env/production_secrets.dart --decrypt --batch lib/env/production_secrets.dart.gpg