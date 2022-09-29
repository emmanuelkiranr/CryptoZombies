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

Lesson 1 - we created new zombie based on random dna, in lesson 2 we'll create new zombie by having our zombies
feed on other lifeforms - once a zombie feeds, it infects the host with a virus. The virus then turns the host into a new zombie that joins your army.  The new zombie's DNA will be calculated from the previous zombie's DNA and the host's DNA.

In Solidity, function execution always needs to start with an external caller. A contract will just sit on the blockchain doing nothing until someone calls one of its functions. So there will always be a msg.sender.

Using msg.sender gives you the security of the Ethereum blockchain — the only way someone can modify someone else's data would be to steal the private key associated with their Ethereum address

NOTE: FOR STRING COMPARISION, Solidity doesn't have native string comparison, so we compare their keccak256 hashes to see if the strings are equal
    require(keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("Vitalik")));

(Note: In Solidity, it doesn't matter which term you put first — both orders are equivalent. However, since our answer checker is really basic, it will only accept one answer as correct — it's expecting ownerZombieCount[msg.sender] to come first.)


Inheritance -  Rather than making one extremely long contract, sometimes it makes sense to split your code logic across multiple contracts to organize the code. Used for organizing your code by grouping similar logic together into different contracts. 
[This can be used for logical inheritance (such as with a subclass, a Cat is an Animal)]
contract A {
    function a() public {}
}
contract B is A {
    function b() public {}

}

if you compile and deploy B, it will have access to both a() and b() (and any other public functions we may define on A).

Storage vs memory data locations
Most of the time you don't need to use these keywords because Solidity handles them by default. State variables (variables declared outside of functions) are by default storage and written permanently to the blockchain, while variables declared inside functions are memory and will disappear when the function call ends.

Mostly used when dealing with Array and Struct in functions

        Declare using the `storage` keyword, like:
    Sandwich storage mySandwich = sandwiches[_index];
        ...in which case `mySandwich` is a pointer to `sandwiches[_index]`
        in storage, and...
    mySandwich.status = "Eaten!";
        ..this will permanently change `sandwiches[_index]`

        If you just want a copy, you can use `memory`:
    Sandwich memory anotherSandwich = sandwiches[_index + 1];
        ...in which case `anotherSandwich` will simply be a copy of the 
        data in memory, and...
    anotherSandwich.status = "Eaten!";
        ...will just modify the temporary variable and have no effect 
        on `sandwiches[_index + 1]`. But you can do this:
    sandwiches[_index + 1] = anotherSandwich;
        ...if you want to copy the changes back into blockchain storage.


Internal vs External

internal is the same as private, except that it's also accessible to contracts that inherit from this contract. (Hey, that sounds like what we want here!).

external is similar to public, except that these functions can ONLY be called outside the contract — they can't be called by other functions inside that contract

Interacting with another contract which is on the blockchain
    - we need to define an interface
     Means in our contract we need to declare those fn which we need to interact with

    contract NumberInterface {
        function getNum(address _myAddress) public view returns (uint); - we end fn declaration with ;
    }

    This is how the compiler knows it's an interface. By including this interface in our dapp's code our contract knows what the other contract's functions look like, how to call them, and what sort of response to expect

    After declaring the interface we can interact with as
    contract MyContract {
        address NumberInterfaceAddress = 0xab38... 
            ^ The address of the FavoriteNumber contract on Ethereum
        NumberInterface numberContract = NumberInterface(NumberInterfaceAddress);
            Now `numberContract` is pointing to the other contract

        function someFunction() public {
            Now we can call `getNum` from that contract:
        uint num = numberContract.getNum(msg.sender);
            ...and do something with `num` here
        }
    }
    In this way, your contract can interact with any other contract on the Ethereum blockchain, as long they expose those functions as public or external.