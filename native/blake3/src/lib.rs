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
    ("finalize",1,finalize)],
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
