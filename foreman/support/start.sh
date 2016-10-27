#!/bin/sh
echo "=> Running start.sh"
echo "=> Foreman mode: $FOREMAN_MODE"

if [ "$FOREMAN_MODE" = "development" ]; then
  echo "=> Switching to development mode"
  export FOREMAN_PATH="$FOREMAN_PATH-development"
  mkdir -p "$FOREMAN_PATH"
fi

echo "=> Moving into $FOREMAN_PATH"
cd "$FOREMAN_PATH" || exit

if [ "$FOREMAN_MODE" = "development" ] && [ ! -e "$FOREMAN_PATH/Procfile" ]; then
  echo "!=> No Procfile: assuming no app"
  echo "!=> Exiting."
  exit 0
fi

if [ "$FOREMAN_MODE" = "production" ] && [ -e "$FOREMAN_PATH/.bootstrap" ]; then
  echo "=> Bootstrapping database"
  bundle exec rake db:create db:migrate apipie:cache db:seed

  rm "$FOREMAN_PATH/.bootstrap"
fi

if [ -n "$@" ]; then
  exec "$@"
else
  exit 0
fi
