#!/bin/bash

echo "post hook"
TSC="$(pwd)/configs/dev/tsconfig.json"
LTSC="$(pwd)/tsconfig.json"
COM="$(pwd)/configs/dev/composer.json"
LCOM="$(pwd)/composer.json"
SCO="$(pwd)/configs/src/initphp/"
LOG="$(pwd)/extra/initphp/logos/"
ASC="$(pwd)/assets/initphp/copy/root/"

cat "$TSC" >"$LTSC"
sed -i -E 's/\"\.\.\/\.\.\//"\.\//g' "$LTSC"

cat "$COM" >"$LCOM"

mkdir -p "$SCO"
touch "$SCO/placeholder"
mkdir -p "$LOG"
touch "$LOG/placeholder"
mkdir -p "$ASC"
touch "$ASC/placeholder"
