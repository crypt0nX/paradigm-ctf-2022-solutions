// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

contract Deployer {
    constructor(bytes memory code) { assembly { return (add(code, 0x20), mload(code)) } }
}

contract EXP{

    fallback() external  {
         assembly {
            let size := extcodesize(address())
            // allocate output byte array - this could also be done without assembly
            // by using o_code = new bytes(size)
            let o_code := mload(0x40)
            // new "memory end" including padding
            mstore(0x40, add(o_code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
            // store length in memory
            mstore(o_code, size)
            // actually retrieve the code, this needs assembly
            extcodecopy(address(), add(o_code, 0x20), 0, size)
            return (add(o_code, 0x20), size)          
        }      
    }


}

contract TEST{
    address public target;
    bytes32 public hash;
    bytes32 public code_hash;
    function solve(bytes memory code) external returns(bytes memory){
        require(code.length > 0);
     //   require(safe(code), "deploy/code-unsafe");
        target = address(new Deployer(code));
        (bool ok, bytes memory result) = target.staticcall("");
        hash = target.codehash;
        code_hash = keccak256(code);
    //    require(
    //        ok &&
     //       keccak256(code) == target.codehash &&
     //       keccak256(result) == target.codehash
    //    );
        return result;
    }
    
    function test() public view returns(bytes memory){
        (bool ok, bytes memory result) = target.staticcall("");
        return result;
    }

    function at(address _addr) public view returns (bytes memory o_code) {
        assembly {
            // retrieve the size of the code, this needs assembly
            let size := extcodesize(_addr)
            // allocate output byte array - this could also be done without assembly
            // by using o_code = new bytes(size)
            o_code := mload(0x40)
            // new "memory end" including padding
            mstore(0x40, add(o_code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
            // store length in memory
            mstore(o_code, size)
            // actually retrieve the code, this needs assembly
            extcodecopy(_addr, add(o_code, 0x20), 0, size)
        }
    }
        
}