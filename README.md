# Unofficial LineageOS 24.0 for OnePlus 5T (`dumpling`)

## Disclaimer

This is an unofficial build for the OnePlus 5T (`dumpling`). It may contain bugs and can cause data loss or device damage. Use it at your own risk; no warranty or liability for damage is assumed. The build and this documentation were created with AI assistance.

However, the developer runs the ROM reliably on his personal phone in everyday use. ;)

## Project goals

- Make LineageOS 24.0 bootable on the OnePlus 5T (done).
- Replace the downstream vendor kernel with a current mainline Linux kernel (working).

The long-term goal is to meet the requirements for official LineageOS support. All OnePlus 5T owners are welcome to test the build and report bugs to help improve its stability and hardware support.

## Install the existing build

The installation itself can be performed from any previous system. The bootloader must already be unlocked. Back up important data before proceeding.

> [!IMPORTANT]
> Before installing, make sure you have updated to the latest STOCK ROM so that the modem drivers are up to date.

### Download the release files

[Download](https://github.com/TheHiddenBranch/LineageOS-OnePlus-5T/releases/latest) all three files from the same release:

- `recovery.img`
- `lineage-24.0-[RELEASE]-UNOFFICIAL-dumpling.zip`
- `lineage-24.0-[RELEASE]-UNOFFICIAL-dumpling.zip.sha256sum`

After downloading, open a terminal in the folder containing the three release files and verify the ZIP checksum:

```bash
sha256sum -c lineage-24.0-[RELEASE]-UNOFFICIAL-dumpling.zip.sha256sum
```

### Flash recovery

Install Android Platform Tools (`adb` and `fastboot`) on the computer. Power off the phone, then hold **Volume Up + Power** to enter bootloader/fastboot mode. Connect the USB cable and confirm that the computer detects the phone:

```bash
fastboot devices
```

Flash the matching recovery image:

```bash
fastboot flash recovery recovery.img
```

Use the phone's volume buttons to select **Recovery** in the bootloader menu and press Power to confirm.

### Install the ROM

> [!NOTE]
> For a **clean install from another ROM**, use **Factory reset → Format data / factory reset** in recovery before sideloading. This erases apps, settings, and files in internal storage.

> [!NOTE]
> For an **update** from this same unofficial LineageOS 24.0 build, do not format data; sideload the newer ZIP from recovery and
reboot.

In recovery, choose **Apply update → Apply from ADB**. Then, from the download
folder on the computer, sideload the ROM:

```bash
adb sideload lineage-24.0-[RELEASE]-UNOFFICIAL-dumpling.zip
```

> [!TIP]
> Optionally, before the first reboot, sideload a [MindTheGapps](https://mindthegapps.com/) package for Android
17 and ARM64.

> [!TIP]
> For root access, sideload a [Magisk](https://github.com/topjohnwu/magisk/releases) package.

After installing the ROM and any optional packages, choose **Reboot system**.

## Build it yourself

> [!NOTE]
> This is for advanced users.

Run commands from the project root unless a step says to change directories.
The source lock records the exact revisions used for a reproducible checkout;
the local patches are kept under `patches/` and applied after syncing.

### Host tools and initial source download

Install the required tools (ccache, git, git-lfs, android-platform-tools) and prepare the workspace:

```bash
git clone https://github.com/TheHiddenBranch/LineageOS-OnePlus-5T.git
mkdir -p logs src tmp

curl -fL --retry 3 https://storage.googleapis.com/git-repo-downloads/repo -o tools/bin/repo
chmod 755 tools/bin/repo
source tools/envsetup.sh
```

Initialize and sync the pinned manifest:

```bash
cd src
repo init -u https://github.com/LineageOS/android.git -b lineage-24.0 \
  --git-lfs --no-clone-bundle --depth=1
cp ../manifests/sources.lock.xml .repo/manifests/sources.lock.xml
if test -f .repo/local_manifests/dumpling.xml; then
  mv .repo/local_manifests/dumpling.xml "../tmp/dumpling-local-$(date -u +%Y%m%dT%H%M%SZ).xml"
fi
repo init -m sources.lock.xml --git-lfs --no-clone-bundle --depth=1

repo sync --fail-fast --no-clone-bundle
repo manifest -r -o "../logs/manifest-$(date -u +%Y%m%dT%H%M%SZ).xml"
cd ..
```

Connect a OnePlus 5T running a compatible, rootable LineageOS build with USB debugging enabled. The extractor is included in the synced Dumpling device tree; see the [LineageOS Dumpling guide](https://wiki.lineageos.org/devices/dumpling/build/#extract-proprietary-blobs). The archive is a local backup, so you only need to extract the files from the phone once; future checkouts can restore them from the archive.

```bash
adb root
cd src/device/oneplus/dumpling
./extract-files.py
cd ../../../..
mkdir -p external/vendor
tar -czf external/vendor/vendor-oneplus.tar.gz -C src \
  vendor/oneplus/dumpling vendor/oneplus/msm8998-common
tar --no-same-owner -xzf external/vendor/vendor-oneplus.tar.gz -C src
```

### Apply the workspace patches

Run from the project root. Check and apply the documented patches in order; stop
and resolve any error before continuing with the build:

```bash
find patches -type f -name '*.patch' | sort | while IFS= read -r patch; do
  repo_path="${patch#patches/}"
  repo_path="${repo_path%/*}"
  git -C "src/$repo_path" apply --check - < "$patch" &&
    git -C "src/$repo_path" apply - < "$patch" || exit 1
done
```

### Configure and build

```bash
cd src
source ../tools/envsetup.sh
source build/envsetup.sh
breakfast dumpling userdebug

build_log="../logs/build-$(date -u +%Y%m%dT%H%M%SZ).log"
m -j$(nproc) bacon recoveryimage > "$build_log" 2>&1
```

The ROM ZIP and recovery image are written under
`src/out/target/product/dumpling/`. `tools/envsetup.sh` enables ccache when it is installed; `ccache -s` reports its statistics. Keep the cache between builds.

### Keep the build current

`manifests/sources.lock.xml` pins exact revisions. Syncing with that lock alone repeats the same source snapshot. To update the main LineageOS 24.0 projects, refresh the rolling manifest while retaining the selected dumpling device, legacy HAL, and kernel revisions in `manifests/dumpling.xml`.

Reverse the patches in reverse filename order. Do not run this against unrelated local changes:

```bash
source tools/envsetup.sh
find patches -type f -name '*.patch' | sort -r | while IFS= read -r patch; do
  repo_path="${patch#patches/}"
  repo_path="${repo_path%/*}"
  git -C "src/$repo_path" apply --check --reverse - < "$patch" &&
    git -C "src/$repo_path" apply --reverse - < "$patch" || exit 1
done
```

Refresh the manifest and sync the newer LineageOS sources:

```bash
cp manifests/sources.lock.xml "logs/sources.lock-before-$(date -u +%Y%m%dT%H%M%SZ).xml"
cd src
repo init -u https://github.com/LineageOS/android.git -b lineage-24.0 \
  -m default.xml --git-lfs --no-clone-bundle --depth=1
mkdir -p .repo/local_manifests &&
cp ../manifests/dumpling.xml .repo/local_manifests/dumpling.xml &&
repo list device/oneplus/dumpling kernel/oneplus/msm8998 &&
repo sync --fail-fast --no-clone-bundle &&
repo manifest -r -o ../tmp/sources.lock.updated.xml
cd ..
```

The project check must list both Dumpling and its kernel. If any command fails,
resolve the error before using the exported manifest or continuing below.

Review the revision changes before replacing the source lock. Then select the new lock so later syncs reproduce this updated source snapshot. The lock already includes the local projects, so move the local manifest aside to avoid duplicate paths:

```bash
diff -u manifests/sources.lock.xml tmp/sources.lock.updated.xml
cp tmp/sources.lock.updated.xml manifests/sources.lock.xml
cd src
cp ../manifests/sources.lock.xml .repo/manifests/sources.lock.xml
if test -f .repo/local_manifests/dumpling.xml; then
  mv .repo/local_manifests/dumpling.xml "../tmp/dumpling-local-$(date -u +%Y%m%dT%H%M%SZ).xml"
fi
repo init -m sources.lock.xml --git-lfs --no-clone-bundle --depth=1
cd ..
```

Reapply the workspace patches using the commands in **Apply the workspace patches**, then rebuild using **Configure and build**. The existing ccache is reused. Review any proposed device-tree or kernel revision changes separately before adopting them.
