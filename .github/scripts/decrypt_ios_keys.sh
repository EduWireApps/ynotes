#!/bin/sh

# --batch to prevent interactive command
# --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$ANDROID_KEYS_SECRET_PASSPHRASE" \
--output ios/AuthKey_YM9RAPWYT7.p8 ios/AuthKey_YM9RAPWYT7.p8.gpg

