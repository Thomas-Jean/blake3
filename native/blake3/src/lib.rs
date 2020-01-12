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
        //atom __true__ = "true";
        //atom __false__ = "false";
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

// fn get_platform_string(plat: Platform) -> String{
//     "x86"
// }

// fn build_hash_info<'a>(hasher: blake3::Hasher) -> rustler::OwnedBinary{
//     let bin: Vec<u8> = bincode::serialize(&hasher).unwrap()
//     let mut bin_copy = types::OwnedBinary::new(bin.len()).unwrap();
// //     let _ = bin_copy.as_mut_slice().write(&bin);

// //     bin_copy
// }

// unsafe fn any_as_u8_slice<T: Sized>(p: &T) -> &[u8] {
//     ::std::slice::from_raw_parts(
//         (p as *const T) as *const u8,
//         ::std::mem::size_of::<T>(),
//     )
// }


// fn build_hasher(hash_info: HashInfo) -> blake3::Hasher {

// }

// fn return_string<'a>(env: Env<'a>, _args: &[Term<'a>]) -> NifResult<Term<'a>> {
//     Ok((atoms::ok(), "Hello world!").encode(env))
// }
