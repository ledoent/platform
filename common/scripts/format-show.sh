#!/bin/sh

roots=$(pnpm ls -r --depth -1 --json | grep '"path":' | cut -d '"' -f 4 | sed "s|^$(pwd)/||")
files="eslint.log prettier.log"
for file in $roots; do
  for check in $files; do
    f="$file/.format/$check"
    if [ -f $f ]; then
      if grep -q "error" "$f"; then
        if ! grep -q "0 errors" "$f"; then
          if ! grep -q "error.ts" "$f"; then
            echo "Errors in $f"
            cat "$f"
          fi
        fi
      fi
    fi
  done
done