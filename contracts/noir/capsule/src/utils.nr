use dep::std;
use dep::aztec::{
    hash::pedersen_hash,
    cryptography::schnorr::{verify_signature as schnorr_verify},
};

pub fn verify_signature(
    public_key: Field,
    message_hash: Field,
    signature: [Field; 2],
) -> bool {
    schnorr_verify(public_key, message_hash, signature)
}

pub fn compute_nullifier(
    owner: Field,
    content_hash: Field,
    nonce: Field,
) -> Field {
    let nullifier_input = [owner, content_hash, nonce];
    pedersen_hash(nullifier_input)
}

pub fn string_to_fields(input: str<32>) -> [Field; 8] {
    let mut result: [Field; 8] = [0; 8];

    result
}

pub fn timestamp_to_field(timestamp: u64) -> Field {
    Field::from(timestamp)
}