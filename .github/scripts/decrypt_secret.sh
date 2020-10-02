#!/bin/sh
sudo gpgconf --kill dirmngr
# sudo chown -R $USER:$USER ~/.gnupg
mkdir -p $HOME/secrets
mkdir -p $HOME/.gnupg/
# touch $HOME/.gnupg/gpg.conf
# touch $HOME/.gnupg/gpg-agent.conf
# echo 'user-agent' > $HOME/.gnupg/gpg.conf
# echo 'pinentry-mode loopback' > $HOME/.gnupg/gpg-agent.conf
# echo 'allow-loopback-pinentry' >> $HOME/.gnupg/gpg-agent.conf
# echo RELOADAGENT | gpg-connect-agent
printf "$GPG_SIGNING_KEY" | base64 --decode > $HOME/.gnupg/private.key
gpg --import $HOME/.gnupg/private.key
gpg --quiet --batch --yes --decrypt --passphrase="$SECRETS_PASSPHRASE" ¥ --output lib/env/production_secrets.dart lib/env/production_secrets.dart.gpg