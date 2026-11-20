# Workspace rules

## Filesystem scope
- Keep all file access and workspace commands within the project root or its descendants. Do not change to, inspect, read, create, modify, or delete paths outside this tree.
- Keep temporary files, logs, and generated artifacts inside the project tree.

## Goal and kernel
- Build LineageOS 24.0 (`lineage-24.0`) for the OnePlus 5T (`dumpling`, Qualcomm MSM8998).
- Use a compatible downstream/vendor kernel, never a mainline kernel.
- Prefer https://github.com/OnePlus-5-T/4.14-kernel-oneplus-msm8998 as the primary kernel. Consult other downstream kernels and upstream sources for individual patches when useful; record patch provenance and rationale.
- Treat the device and kernel combination as a port until compilation and hardware testing establish compatibility. Do not claim it boots without device evidence.

## Directory layout
- `src/`: Android/LineageOS repo checkout, including device trees and kernel sources.
- `manifests/`: version-controlled local manifest templates, copied into `src/.repo/local_manifests/` during initialization.
- `external/vendor/`: user-supplied vendor files. Preserve the original archives and checksums; validate them before use.
- `external/references/`: comparison sources and other references that do not participate in the build. Keep them outside `src/` and the Android build manifests, with independent Git metadata and recorded origin revisions. Do not add build-exclusion patches for reference-only repositories.
- `patches/<repository-path>/`: patches for each individual repository, mirroring its path under `src/`. Put a `README.md` beside each repository's patches describing what they change and why they are necessary.
- `logs/`: setup, synchronization, build, and diagnostic logs, using timestamped filenames and explicit exit status.
- `tmp/`: temporary scripts, downloads, inspection output, and working files.
- `tools/`: persistent local tooling and reusable workspace entry points.
- Write all code comments, READMEs, patch explanations, and other project documentation in English.
- Use only relative filesystem paths in documentation, including patch READMEs and command examples. Start reproduction instructions in the project root and state any working-directory changes. Never embed usernames or machine-specific absolute paths; documented commands must work regardless of the project location or active user.

## Execution and resources
- When reporting a build, always state its status, the current build log, the newly generated artifact filenames, and which artifacts are needed for the next step. Distinguish completed diagnostic builds from fixes that have not yet been implemented or built.
- Do not periodically inspect download or build progress. After starting and verifying launch once, wait for the user to report completion before examining results. Do not create polling loops, watch commands, scheduled checks, or automatic progress monitors.
- Preserve existing work and proprietary files. Do not use destructive sync/reset/clean options or overwrite existing patches without inspecting them first.
- Keep build-specific environment and Git configuration local to this workspace rather than changing the user's global configuration.
- Record reproducible manifest choices and downloaded revisions. Do not silently substitute a different LineageOS release or kernel.

## Patch discipline
- Create repository-specific directories and READMEs in `patches/` only when creating actual patches that must be applied to the source code. Do not create placeholder READMEs, speculative patch plans, or empty repository scaffolding. Keep general patch rules in this file.
- Keep patches focused and grouped by affected repository. Prefer standard Git patches that can be checked and applied reproducibly.
- Document every source modification needed for the port in `patches/`, including device-tree and build-system changes.
- Verify patch application and run relevant checks before describing a fix as working. Separate source synchronization, compilation success, and on-device validation.
- Verify intended diagnostic changes in the packed boot image. When an init or kernel code change is expected, compare that payload with the previous image before requesting another device test.
- Before the next firmware build, remove the added diagnostic settings and temporary runtime instrumentation. Build and verify normal boot images with SELinux enforcing, without cache-backed boot logging, unrestricted userspace kmsg, or diagnostic fatal-reboot targets. Use direct Android ADB for further diagnostics; do not produce or request another diagnostic boot image unless explicitly requested.
