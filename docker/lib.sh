
die() {
  echo "ERROR: $1"
  exit 1
}

set_defaults() {
  [ -z "$HOST" ]       && export HOST="0.0.0.0"
  [ -z "$PORT" ]       && export PORT="3141"
  [ -z "$SERVER_DIR" ] && export SERVER_DIR="/var/lib/devpi"
  [ -z "$ROLE" ]       && export ROLE="auto"
}
