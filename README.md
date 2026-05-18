# v-claw-release

Release feed for the V-Claw Electron desktop shell.

## Auto-update feed

The Electron shell uses `electron-updater` with the GitHub Releases provider:

- Owner: `cong91`
- Repository: `v-claw-release`
- Release type: stable GitHub Releases

For each shell version, upload the generic auto-update artifacts from:

```text
v-claw-app/release/auto-update/
```

Required Windows assets:

- `latest.yml`
- the generic `V-Claw Setup <version>.exe`
- `*.blockmap` files generated next to the generic installer

These generic artifacts are the files consumed by `electron-updater`. The generic
setup executable is built with fallback attribution metadata:

```json
{
  "aff_code": "AUTO_APPROVAL",
  "source": "windows-auto-update-build",
  "fallbackOnly": true
}
```

This means a direct first install from the update-feed executable can still enter
the app through `AUTO_APPROVAL`, while an existing installation keeps its already
persisted affiliate code during shell updates. Do not use affiliate-suffixed
installers as the update feed assets.

## Affiliate installers

Affiliate installers remain first-install distribution artifacts. They are built
from `v-claw-app/aff_codes.txt` by `v-claw-app/build-app-win.bat` and keep the
existing naming pattern:

```text
V-Claw Setup <version>-aff_<AFF_CODE>.exe
```

The affiliate code is captured from `resources/install/install-attribution.generated.json`
on first launch and persisted in the user's app-state data. Shell updates replace
application files, not the user-data app-state file, so subsequent generic updates
do not need affiliate-specific installers.

## Standard build + GitHub release upload command

Use this wrapper from this `v-claw-release` repository whenever publishing a
Windows release:

```bat
build-and-push-release.bat 1.0.0 --latest=false
build-and-push-release.bat 1.0.1 --latest=true
```

The wrapper calls `v-claw-app/scripts/build-and-publish-win-release.js`, which:

1. patches `v-claw-app/package.json` and `package-lock.json` to the requested
   version for the build,
2. runs `v-claw-app/build-app-win.bat` non-interactively,
3. stages assets from `v-claw-app/release/auto-update/latest.yml`,
4. uploads the generic installer using the exact `path`/`url` filename from
   `latest.yml` (`V-Claw-Setup-<version>.exe`),
5. renames affiliate installers to the same hyphen format before upload, and
6. deletes/recreates the GitHub release in `cong91/v-claw-release`.

To validate filenames without uploading:

```bat
build-and-push-release.bat 1.0.1 --no-build --dry-run
```

Do not manually upload dot-format assets such as `V-Claw.Setup.1.0.1.exe`; the
auto-updater metadata points to hyphen-format assets.

## Windows build flow

Run the Windows build script from `v-claw-app/`:

```bat
build-app-win.bat
```

The script builds the generic auto-update artifact set first, copies it into
`release\auto-update\`, then builds one affiliate first-install installer for each
valid code in `aff_codes.txt`.

## Signing and platform scope

Windows auto-updates should use signed installers for production distribution.
Unsigned installers may trigger operating-system warnings or updater validation
issues depending on the user's environment.

This repository currently documents the Windows NSIS update feed. macOS and Linux
auto-update rollout are out of scope until their artifact targets and signing
requirements are defined.
