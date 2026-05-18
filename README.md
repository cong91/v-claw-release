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

These generic artifacts are the files consumed by `electron-updater`. Do not use
affiliate-suffixed installers as the update feed assets.

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
