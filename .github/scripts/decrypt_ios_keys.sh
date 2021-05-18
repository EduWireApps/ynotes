#!/bin/sh

# --batch to prevent interactive command
# --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$ANDROID_KEYS_SECRET_PASSPHRASE" \
--output ios/AuthKey_5R2MFY6PX4.p8 ios/AuthKey_5R2MFY6PX4.p8.gpg

