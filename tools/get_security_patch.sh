#!/bin/bash


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

grep -n 'security_patch' "$PARENT_DIR/src/out/target/product/dumpling/system/build.prop"
