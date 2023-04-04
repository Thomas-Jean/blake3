# Changelog

## v1.0.1

- Fixes
  - support Apple ARM hardware

## v1.0.0

- Enhancements

  - updated blake3 version to 1.3.3
  - updated rustler to 0.22.2

- Other
  - add github actions release workflow
  - fix CI
  - Release version injection

## v0.5.0 (unreleased)

- Enhancements

  - updated blake3 version to 1.0.0
  - updated rustler to 0.22.1
  - refactored Rust crate to use the rustler::nif macro

- Breaking changes

  - `update_with_join` has been replacted with `update_rayon` to reflect the
    same change in the upstream `blake3` crate. This function is only available
    when the `rayon` feature flag is enabled, and will panic otherwise.

## v0.4.0

- Enhancements

  - updated blake package version
  - `c` flag deprecated as it is now on be default
  - `c_neon` additional alias `neon` to match feature name in rust lib

## v0.3.0

- Enhancements

  - updated blake package version
  - added support to reset hasher with `reset`
  - blake3 rust features can be enabled by env var or mix config (need to recompile the library)
  - multi-threading is now enabled via setting the `rayon` feature
  - when multi-threading is enable `update_with_join` is used to to parallelize
  - SIMD features enabled be set with `simd_mode`

## v0.2.0

- Enhancements

  - updated blake package version
  - added support for keyed hashes with `new_keyed`, `keyed_hash`, and `derive_key`

- Bug fixes
  - fix link in docs to readme

## v0.1.0

- Initial Release
  - basic and streaming hashing with `new`, `update`, `finalize` and `hash`
