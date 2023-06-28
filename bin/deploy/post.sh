#!/bin/bash

echo "post hook"
TSC="$(pwd)/configs/dev/tsconfig.json"
LTSC="$(pwd)/tsconfig.json"
COM="$(pwd)/configs/dev/composer.json"
LCOM="$(pwd)/composer.json"

cat "$TSC" >"$LTSC"
sed -i -E 's/\"\.\.\/\.\.\//"\.\//g' "$LTSC"

cat "$COM" >"$LCOM"

/bin/bash "$(pwd)/bin/deploy/fix.sh"
