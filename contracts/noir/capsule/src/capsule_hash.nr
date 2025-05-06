use dep::std;
use dep::aztec::hash::pedersen_hash;

pub fn compute_capsule_hash(
    content: [Field; 32],
    metadata: [Field; 8],
    timestamp: Field,
    nonce: Field,
) -> Field {
    let content_hash = pedersen_hash(content);
    
    let metadata_hash = pedersen_hash(metadata);
    
    let combined = [content_hash, metadata_hash, timestamp, nonce];
    pedersen_hash(combined)
}

pub fn compute_metadata_hash(metadata: [Field; 8]) -> Field {
    pedersen_hash(metadata)
}

pub fn compute_content_hash(content: [Field; 32]) -> Field {
    pedersen_hash(content)
}