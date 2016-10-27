#!/bin/bash

if [ "$FOREMAN_MODE" = "production" ]; then
  echo "=> Switching to Foreman version: $FOREMAN_VERSION"
  git fetch origin
  git checkout "$FOREMAN_VERSION" || exit
fi

echo "=> Bundle without: $BUNDLE_WITHOUT"
bundle --without "$BUNDLE_WITHOUT"

echo "=> Installing node modules"
npm install
npm prune

echo "=> Compiling assets"
DB_ADAPTER=nulldb bundle exec rake assets:clean assets:precompile webpack:compile

touch "$FOREMAN_PATH/.bootstrap"
