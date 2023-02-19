#[macro_use]
extern crate rustler;
extern crate rustler_codegen;

extern crate blake3;

use rustler::resource::ResourceArc;
use rustler::{types, Binary, Env, Error, NifResult, OwnedBinary, Term};
use std::io::Write;
use std::sync::Mutex;

pub struct HasherResource(Mutex<blake3::Hasher>);

rustler::init!(
    "Elixir.Blake3.Native",
    [
        hash,
        new,
        update,
        finalize,
        derive_key,
        keyed_hash,
        new_keyed,
        reset,
        update_rayon
    ],
    load = on_load
);

fn on_load(env: Env, _info: Term) -> bool {
    resource!(HasherResource, env);
    true
}

mod atoms {
    rustler::atoms! {
        ok,
        error,
    }
}

#[rustler::nif]
fn hash<'a>(env: Env<'a>, buf: Binary) -> NifResult<Binary<'a>> {
    let hash = blake3::hash(&buf);
    let hash_bytes = hash.as_bytes();

    let mut bin = OwnedBinary::new(hash_bytes.len()).ok_or(Error::Term(Box::new("no mem")))?;
    let _ = bin.as_mut_slice().write(hash_bytes);

    Ok(bin.release(env))
}

#[rustler::nif]
fn new() -> ResourceArc<HasherResource> {
    ResourceArc::new(HasherResource(Mutex::new(blake3::Hasher::new())))
}

#[rustler::nif]
fn update(resource: ResourceArc<HasherResource>, buf: Binary) -> ResourceArc<HasherResource> {
    {
        let mut hasher = resource.0.try_lock().unwrap();
        hasher.update(&buf);
    }

    resource
}

#[rustler::nif]
fn finalize<'a>(env: Env<'a>, resource: ResourceArc<HasherResource>) -> NifResult<Binary<'a>> {
    let hasher = resource.0.try_lock().unwrap();
    let hash_: blake3::Hash = hasher.finalize();
    let hash_bytes = hash_.as_bytes();

    let mut bin =
        types::OwnedBinary::new(hash_bytes.len()).ok_or(Error::Term(Box::new("no mem")))?;
    let _ = bin.as_mut_slice().write(hash_bytes);

    Ok(bin.release(env))
}

#[rustler::nif]
fn derive_key<'a>(env: Env<'a>, context: &str, input_key: Binary) -> NifResult<Binary<'a>> {
    let key = blake3::derive_key(context, &input_key);

    let mut bin = types::OwnedBinary::new(key.len()).ok_or(Error::Term(Box::new("no mem")))?;
    let _ = bin.as_mut_slice().write(&key);

    Ok(bin.release(env))
}

#[rustler::nif]
fn keyed_hash<'a>(env: Env<'a>, key: Binary, buf: Binary) -> NifResult<Binary<'a>> {
    let mut key_bytes: [u8; 32] = [0; 32];
    key_bytes.copy_from_slice(key.as_slice());

    let hash_ = blake3::keyed_hash(&key_bytes, &buf);
    let hash_bytes = hash_.as_bytes();

    let mut bin = types::OwnedBinary::new(hash_bytes.len()).unwrap();
    let _ = bin.as_mut_slice().write(hash_bytes);

    Ok(bin.release(env))
}

#[rustler::nif]
fn new_keyed<'a>(key: Binary) -> ResourceArc<HasherResource> {
    let mut key_bytes = [0; 32];
    key_bytes.copy_from_slice(key.as_slice());

    ResourceArc::new(HasherResource(Mutex::new(blake3::Hasher::new_keyed(
        &key_bytes,
    ))))
}

#[rustler::nif]
fn reset<'a>(resource: ResourceArc<HasherResource>) -> ResourceArc<HasherResource> {
    {
        let mut hasher = resource.0.try_lock().unwrap();
        let _ = hasher.reset();
    }

    resource
}

#[cfg(feature = "rayon")]
#[rustler::nif]
fn update_rayon<'a>(
    resource: ResourceArc<HasherResource>,
    buf: Binary,
) -> ResourceArc<HasherResource> {
    {
        let mut hasher = resource.0.try_lock().unwrap();
        hasher.update_rayon(&buf);
    }
    resource
}

#[cfg(not(feature = "rayon"))]
#[rustler::nif]
fn update_rayon<'a>(
    _resource: ResourceArc<HasherResource>,
    _buf: Binary,
) -> ResourceArc<HasherResource> {
    panic!("Blake3.update_rayon() called without rayon feature enabled");
}
