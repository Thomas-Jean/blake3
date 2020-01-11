#[macro_use] extern crate rustler;
extern crate rustler_codegen;
extern crate blake3;

use rustler::{Env, Term, NifResult, Encoder, types};
use std::io::Write;


rustler_export_nifs!(
    "Elixir.Blake3.Native", 
    [("hash", 1, hash)],
    None
);


mod atoms {
    rustler_atoms! {
        atom ok;
        atom error;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}

fn hash<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let x : types::Binary = args[0].decode()?;
    let hash = blake3::hash(&x);
    let hash_bytes = hash.as_bytes();

    let mut bin = types::OwnedBinary::new(hash_bytes.len()).unwrap();
    let _ = bin.as_mut_slice().write(hash_bytes);


    Ok((bin.release(env)).encode(env))

}





// fn return_string<'a>(env: Env<'a>, _args: &[Term<'a>]) -> NifResult<Term<'a>> {
//     Ok((atoms::ok(), "Hello world!").encode(env))
// }
