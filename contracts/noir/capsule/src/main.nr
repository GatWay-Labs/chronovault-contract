use dep::std;
use dep::aztec::{
    note::{
        note_header::NoteHeader,
        note_interface::NoteInterface,
    },
    context::Context,
    hash::pedersen_hash,
};

mod capsule_hash;
mod utils;

use crate::capsule_hash::compute_capsule_hash;
use crate::utils::{verify_signature, compute_nullifier};

struct CapsuleNote {
    owner: Field,
    content_hash: Field,
    metadata_hash: Field,
    timestamp: Field,
    nonce: Field,
}

impl NoteInterface for CapsuleNote {
    fn note_header(&self) -> NoteHeader {
        NoteHeader {
            note_type: 1, 
            version: 1,  
            creator: self.owner,
        }
    }

    fn serialize(&self) -> [Field; 5] {
        [
            self.owner,
            self.content_hash,
            self.metadata_hash,
            self.timestamp,
            self.nonce,
        ]
    }

    fn deserialize(fields: [Field; 5]) -> Self {
        CapsuleNote {
            owner: fields[0],
            content_hash: fields[1],
            metadata_hash: fields[2],
            timestamp: fields[3],
            nonce: fields[4],
        }
    }
}

fn create_capsule(
    context: Context,
    owner: Field,
    content: [Field; 32],
    metadata: [Field; 8],
    timestamp: Field,
    nonce: Field,
    signature: [Field; 2],
) -> pub Field {
    let message_hash = compute_capsule_hash(content, metadata, timestamp, nonce);
    verify_signature(owner, message_hash, signature);

    let content_hash = pedersen_hash(content);
    let metadata_hash = pedersen_hash(metadata);

    let note = CapsuleNote {
        owner,
        content_hash,
        metadata_hash,
        timestamp,
        nonce,
    };

    let nullifier = compute_nullifier(owner, content_hash, nonce);

    nullifier
}

fn open_capsule(
    context: Context,
    owner: Field,
    content_hash: Field,
    metadata_hash: Field,
    timestamp: Field,
    nonce: Field,
    signature: [Field; 2],
) -> pub Field {
    let message = [owner, content_hash, metadata_hash, timestamp, nonce];
    let message_hash = pedersen_hash(message);
    verify_signature(owner, message_hash, signature);

    let nullifier = compute_nullifier(owner, content_hash, nonce);

    nullifier
}

fn verify_ownership(
    context: Context,
    owner: Field,
    content_hash: Field,
    nonce: Field,
    signature: [Field; 2],
) -> pub bool {
    let message = [owner, content_hash, nonce];
    let message_hash = pedersen_hash(message);
    let is_valid = verify_signature(owner, message_hash, signature);

    is_valid
}