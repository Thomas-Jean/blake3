#[macro_use] extern crate rustler;
extern crate rustler_codegen;

extern crate blake3;

use rustler::{Env, Term, NifResult, Encoder, types};
use rustler::resource::ResourceArc;
use std::io::Write;
use std::sync::Mutex;

pub struct HasherResource(Mutex<blake3::Hasher>);

rustler_export_nifs!(
    "Elixir.Blake3.Native", 
    [("hash", 1, hash),
    ("new",0, new),
    ("update",2,update),
    ("update_with_join",2,update_with_join),
    ("finalize",1,finalize),
    ("derive_key",2,derive_key),
    ("keyed_hash",2,keyed_hash),
    ("new_keyed",1,new_keyed),
    ("reset",1,reset)],
    Some(on_load)
);


mod atoms {
    rustler_atoms! {
        atom ok;
        atom error;
    }
}

fn on_load(env: Env, _info: Term) -> bool {
    resource_struct_init!(HasherResource, env);
    true
}

fn hash<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let buf : types::Binary = args[0].decode()?;
    let hash = blake3::hash(&buf);
    let hash_bytes = hash.as_bytes();

    let mut bin = types::OwnedBinary::new(hash_bytes.len()).unwrap();
    let _ = bin.as_mut_slice().write(hash_bytes);

    Ok((bin.release(env)).encode(env))

}

fn new<'a>(env: Env<'a>, _args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let hasher = ResourceArc::new(HasherResource(Mutex::new(blake3::Hasher::new())));
    
    Ok((hasher).encode(env))
}

fn update<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let resource: ResourceArc<HasherResource> = args[0].decode()?;
    let buf : types::Binary = args[1].decode()?;


    let mut hasher = resource.0.try_lock().unwrap();
    hasher.update(&buf);

    Ok((resource).encode(env))

}

fn finalize<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let resource: ResourceArc<HasherResource> = args[0].decode()?;

    let hasher = resource.0.try_lock().unwrap();
    let hash: blake3::Hash = hasher.finalize();
    let hash_bytes = hash.as_bytes();

    let mut bin = types::OwnedBinary::new(hash_bytes.len()).unwrap();
    let _ = bin.as_mut_slice().write(hash_bytes);

    Ok((bin.release(env)).encode(env))

}

fn derive_key<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let context : &str = args[0].decode()?;
    let input_key : types::Binary = args[1].decode()?;

    let mut key = [0; 32];
    blake3::derive_key(context, &input_key, &mut key);

    let mut bin = types::OwnedBinary::new(key.len()).unwrap();
    let _ = bin.as_mut_slice().write(&key);

    Ok((bin.release(env)).encode(env))
}

fn keyed_hash<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let key : types::Binary = args[0].decode()?;
    let buf : types::Binary = args[1].decode()?;

    let mut key_bytes = [0; 32];
    let _ = key_bytes.copy_from_slice(key.as_slice());

    let hash = blake3::keyed_hash(&key_bytes, &buf);
    let hash_bytes = hash.as_bytes();

    let mut bin = types::OwnedBinary::new(hash_bytes.len()).unwrap();
    let _ = bin.as_mut_slice().write(hash_bytes);

    Ok((bin.release(env)).encode(env))

}

fn new_keyed<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let key : types::Binary = args[0].decode()?;

    let mut key_bytes = [0; 32];
    let _ = key_bytes.copy_from_slice(key.as_slice());

    let hasher = ResourceArc::new(HasherResource(Mutex::new(blake3::Hasher::new_keyed(&key_bytes))));
    
    Ok((hasher).encode(env))

}

fn reset<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let resource: ResourceArc<HasherResource> = args[0].decode()?;

    let mut hasher = resource.0.try_lock().unwrap();
    let _ = hasher.reset();

    Ok((resource).encode(env))
}

fn update_with_join<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let resource: ResourceArc<HasherResource> = args[0].decode()?;
    let buf : types::Binary = args[1].decode()?;


    let mut hasher = resource.0.try_lock().unwrap();
    #[cfg(feature = "rayon")]{
        hasher.update_with_join::<blake3::join::RayonJoin>(&buf);
    }

    #[cfg(not(feature = "rayon"))]{
        hasher.update_with_join::<blake3::join::SerialJoin>(&buf);
    }

    Ok((resource).encode(env))

}
