pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

contract KittyInterface { // interface to interact with cryptoKitty contract
    function getKitty(uint256 _id) external view returns(
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  // address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;

  // Initialize kittyContract here using `ckAddress` from above
  // KittyInterface kittyContract = KittyInterface(ckAddress); 
  KittyInterface kittyContract;

  function setKittyContractAddress(address _address) external onlyOwner{
    kittyContract = KittyInterface(_address);
  }
  // Helper funtions
  // 1. Define `_triggerCooldown` function here
  function _triggerCooldown(Zombie storage _zombie) internal { // passing a storage pointer to struct as argument
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  // 2. Define `_isReady` function here
  function _isReady(Zombie storage _zombie) internal view returns(bool) {
    return (_zombie.readyTime <= now);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal { // change to internal
  // cause any user can directly call this fn and pass any dna and species type as they want - This fn only needs to be called by feedOnKitty()
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    // Add a check for `_isReady` here
    require(_isReady(myZombie));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if(keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))){
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    // Call `_triggerCooldown`
    _triggerCooldown(myZombie);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public { 
    //The zombie with _zombieId (owned by a msg.sender) is feeding on a cryptokitty with _kittyId which has the dna kittyDna
    uint kittyDna;
    (,,,,,,,,, kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}




   
