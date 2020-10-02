#!/bin/zsh
mkdir $HOME/secrets
touch $HOME/.gnupg/gpg.conf
touch $HOME/.gnupg/gpg-agent.conf
echo 'user-agent' > ~/.gnupg/gpg.conf
echo 'pinentry-mode loopback' > ~/.gnupg/gpg-agent.conf
echo 'allow-loopback-pinentry' >> ~/.gnupg/gpg-agent.conf
echo RELOADAGENT | gpg-connect-agent
printf "$GPG_SIGNING_KEY" | base64 --decode > $HOME/secrets/private.key
gpg --import $HOME/secrets/private.key
# gpg --quiet --batch --yes --decrypt --passphrase="$SECRETS_PASSPHRASE" ¥ --output lib/env/production_secrets.dart lib/env/production_secrets.dart.gpg