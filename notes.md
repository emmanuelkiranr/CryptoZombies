Reference types - arrays, structs, mappings, and strings

[] By value, which means that the Solidity compiler creates a new copy of the parameter's value and passes it to your function. This allows your function to modify the value without worrying that the value of the initial parameter gets changed.

[] By reference, which means that your function is called with a... reference to the original variable. Thus, if your function changes the value of the variable it receives, the value of the original variable gets changed. [reference values are called using storage data location while updating]

Random Number Generation and Typecasting

Ethereum has the hash function keccak256 built in, which is a version of SHA3. A hash function basically maps an input into a random 256-bit hexadecimal number. A slight change in the input will cause a large change in the hash.
Also important, keccak256 expects a single parameter of type bytes. This means that we have to "pack" any parameters before calling keccak256:
    //6e91ec6b618bb462a4a6ee5aa2cb0e9cf30f7a052bb467b0ba58b8748c00d2e5
    keccak256(abi.encodePacked("aaaab"));
    //b1f078126895a1424524de5321b339ab00408010b7cf0e6ed451514981e58aa9
    keccak256(abi.encodePacked("aaaac"));

    Ref 
    function randNum(uint256 num) internal returns (uint256) {
        // increase nonce
        randNonce++;
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        randNonce
                    )
                )
            ) % num;
    }

Array Index

array.push() returns a uint of the new length of the array - and since the first item in an array has index 0, array.push() - 1 will be the index of the item we just added

uint id = zombies.push(Zombie(_name, _dna)) - 1;