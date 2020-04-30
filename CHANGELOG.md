# Changelog

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
