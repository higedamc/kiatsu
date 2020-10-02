#!/bin/sh
# sudo gpgconf --kill dirmngr
mkdir -p $HOME/secrets
mkdir -p $HOME/.gnupg/
# For macOS
chmod 600 $HOME/.gnupg
echo 'GPG_TTY=$(tty)' > $HOME/.bashrc
echo 'export GPG_TTY' >> $HOME/.bashrc
source $HOME/.bashrc
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install pinentry-mac
# touch $HOME/.gnupg/gpg.conf
# touch $HOME/.gnupg/gpg-agent.conf
# echo 'user-agent' > $HOME/.gnupg/gpg.conf
# echo 'pinentry-mode loopback' > $HOME/.gnupg/gpg-agent.conf
# echo 'allow-loopback-pinentry' >> $HOME/.gnupg/gpg-agent.conf
chmod 600 $HOME/.gnupg/*
echo "pinentry-program `which pinentry-mac`" > $HOME/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent
# End
printf "$GPG_SIGNING_KEY" | base64 --decode > $HOME/.gnupg/private.key
gpg --import $HOME/.gnupg/private.key
# printenv | grep $SECRETS_PASSPHRASE
# gpg --quiet --batch --yes --passphrase="$SECRETS_PASSPHRASE" --output lib/env/production_secrets.dart --decrypt lib/env/production_secrets.dart.gpg
echo $SECRETS_PASSPHRASE | gpg --passphrase-fd 0 --output lib/env/production_secrets.dart --decrypt --batch lib/env/production_secrets.dart.gpg