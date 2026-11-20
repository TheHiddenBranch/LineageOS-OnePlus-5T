#!/usr/bin/env bash
# Source this file before invoking repo or the Android build environment.
export DUMPLING_WORKSPACE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="$DUMPLING_WORKSPACE/tools/bin:$PATH"
export GIT_CONFIG_GLOBAL="$DUMPLING_WORKSPACE/tools/gitconfig"
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
export BUILD_JOBS="$(nproc)"
export MAKEFLAGS="-j$BUILD_JOBS"

# Cache C/C++ compiler outputs for later build attempts.
if command -v ccache >/dev/null 2>&1; then
  export USE_CCACHE=1
  export CCACHE_EXEC="$(command -v ccache)"
  export CCACHE_DIR="${CCACHE_DIR:-/storage/lineage-ccache}"
  if ! "$CCACHE_EXEC" -M 50G; then
    printf 'Could not configure ccache at %s; disabling ccache.\n' "$CCACHE_DIR" >&2
    export USE_CCACHE=0
  fi
else
  export USE_CCACHE=0
  printf 'ccache is not installed; install it with: sudo emerge --ask dev-util/ccache\n' >&2
fi

# Enable the optional host swap file.
SWAP_FILE=/storage/android-build.swap
if [[ -f "$SWAP_FILE" ]] && ! grep -Fq -- "$SWAP_FILE" /proc/swaps; then
  sudo swapon "$SWAP_FILE"
fi
unset SWAP_FILE
