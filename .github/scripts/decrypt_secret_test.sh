#!/bin/sh
set -eo pipefail
git config --global gpg.program $(which gpg)
# mkdir -p ~/.gnupg
# echo 'GPG_TTY=$(tty)' > ~/.zshrc
# echo 'export GPG_TTY' >> ~/.zshrc
# source ~/.zshrc
# echo "no-tty" >> ~/.gnupg/gpg.conf
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# brew install pinentry-mac
# echo "pinentry-program `which pinentry-mac`" > ~/.gnupg/gpg-agent.conf
# gpgconf --kill gpg-agent
# printf "$GPG_SIGNING_KEY" | base64 --decode > ~/.gnupg/private.key
# gpg --import ~/.gnupg/private.key
# printenv | grep $SECRETS_PASSPHRASE
gpg --import $BLACKBOX_PRIVKEY
echo $SECRETS_PASSPHRASE | gpg --passphrase-fd 0 --output lib/env/production_secrets.dart --decrypt --batch lib/env/production_secrets.dart.gpg
echo $SECRETS_PASSPHRASE | gpg --passphrase-fd 0 --output ios/Runner/GoogleService-Info.plist --decrypt --batch ios/Runner/GoogleService-Info.plist.gpg