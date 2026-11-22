#!/bin/bash


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

sed -n 's/.*string_value: "\([^"]*\)".*/\1/p' \
  "$PARENT_DIR/src/vendor/lineage/release/flag_values/cp2a/RELEASE_PLATFORM_SECURITY_PATCH.textproto"
