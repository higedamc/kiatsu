#!/bin/sh
set -eo pipefail
# git config --global gpg.program $(which gpg)
ls -a
echo 'GPG_TTY=$(tty)' > ~/.zshrc
echo 'export GPG_TTY' >> ~/.zshrc
source ~/.zshrc
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install gnupg pinentry-mac
mkdir -p ~/.gnupg
echo "pinentry-program `which pinentry-mac`" > ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent
# export GPG_TTY=$(tty)
# mkdir -p ~/.gnupg


# echo "no-tty" >> ~/.gnupg/gpg.conf

# mkdir ~/.gnupg
# touch ~/.gnupg/gpg-agent.conf
# echo "pinentry-program `which pinentry-mac`" > ~/.gnupg/gpg-agent.conf
# gpgconf --kill gpg-agent
touch private.key
printf "$GPG_SIGNING_KEY" | base64 --decode > private.key
# gpg --import ~/.gnupg/private.key
# printenv | grep $SECRETS_PASSPHRASE
gpg --import private.key
echo $SECRETS_PASSPHRASE | gpg --passphrase-fd 0 --output lib/env/production_secrets.dart --decrypt --batch lib/env/production_secrets.dart.gpg
echo $SECRETS_PASSPHRASE | gpg --passphrase-fd 0 --output ios/Runner/GoogleService-Info.plist --decrypt --batch ios/Runner/GoogleService-Info.plist.gpg