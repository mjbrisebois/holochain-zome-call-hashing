# Holochain Zome Call Hashing
A Javascript WASM binding for creating a hash of Holochain zome call input which is required for
zome call signing.


## Install

```bash
npm i @whi/holochain-zome-call-hashing
```


## Basic Usage
Example of hashing zome call input and adding a signature.

```js
const nacl = require('tweetnacl');
const { encode } = require('@msgpack/msgpack');
const { hashZomeCall } = require('@whi/holochain-zome-call-hashing');
const { AgentPubKey } = require('@whi/holo-hash');

const key_pair = nacl.sign.keyPair();

const zome_call_request = {
    "cell_id": [ dna_hash, agent_hash ], // These are HoloHashes (aka Uint8Arrays)
    "zome_name": "zome_name",
    "fn_name": "function_name",
    "payload": encode( Buffer.from("Super important bytes") ),

    "cap": null,
    "provenance": new AgentPubKey( key_pair.publicKey ),
    "nonce": nacl.randomBytes( 32 ),
    "expires_at": (Date.now() + (5 * 60 * 1_000)) * 1_000,
};

const zome_call_hash = await hashZomeCall( zome_call_request );

zome_call_request.signature = nacl.sign( zome_call_hash, key_pair.secretKey )
    .subarray( 0, nacl.sign.signatureLength );
```


### Support for webpack
Use `import()` instead of `require()`.

```js
const { hashZomeCall } = await import('@whi/holochain-zome-call-hashing');
```

Things you might need to add to a webpack config.
```js
    ...
    experiments: {
        asyncWebAssembly: true,
    },
    resolve: {
        mainFields: ["module", "main"],
    },
    ...
```
