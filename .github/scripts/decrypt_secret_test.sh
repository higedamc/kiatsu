#!/bin/sh
set -eo pipefail
sudo gpgconf --kill dirmngr
# mkdir -p $HOME/.gnupg
# echo 'GPG_TTY=$(tty)' > ~/.zshrc
# echo 'export GPG_TTY' >> ~/.zshrc
export GPG_TTY=$(tty)
# source ~/.zshrc
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install pinentry-mac
echo "pinentry-program `which pinentry-mac`" > $HOME/.gnupg/gpg-agent.conf
printf "$GPG_SIGNING_KEY" | base64 --decode > $HOME/.gnupg/private.key
gpg --import $HOME/.gnupg/private.key
# printenv | grep $SECRETS_PASSPHRASE
# gpg --quiet --batch --yes --passphrase="$SECRETS_PASSPHRASE" --output lib/env/production_secrets.dart --decrypt lib/env/production_secrets.dart.gpg
echo $SECRETS_PASSPHRASE | gpg --passphrase-fd 0 --output lib/env/production_secrets.dart --decrypt --batch lib/env/production_secrets.dart.gpg
echo $SECRETS_PASSPHRASE | gpg --passphrase-fd 0 --output ios/Runner/GoogleService-Info.plist --decrypt --batch ios/Runner/GoogleService-Info.plist.gpg