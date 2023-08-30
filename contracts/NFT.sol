// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// ECR721 Non-Fungible Token
contract NFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string private _blindBoxUri = "ipfs://QmWhThcnoqBYYamNTZrPjs3hH7TsD7fmJ5CPepVrsQ8tvY";
    bool private _isBlindBoxOpened = false;

    address[] private _whiteListedAccounts =  [0xa2Ab56a9943654d35740dbAf95C5Afd4B6bC5c00, 0xA242282D42Ca752eECb1c95125FBCfF748005490, 0x7fE685c8ff7f0299f9552257278bE6bc44EB0e3E];

    // declare the name and symbol of our platform NFTs
    constructor() public ERC721("TestNFT", "NFT") {
        _setBaseURI(_blindBoxUri);
    }

    // set blind box open status
    function setIsBlindBoxOpened(bool _status) public onlyOwner {
        if(_status == true){
            _setBaseURI("");
        }else{
            _setBaseURI(_blindBoxUri);
        }
        _isBlindBoxOpened = _status;
    }

    // get blind box open status
    function getBlindBoxStatus() public view onlyOwner returns (string memory) {
        if(_isBlindBoxOpened) return "true";
        return "false";
    }

    // overwrite the ERC721 tokenURI function to control the return value for blind box
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = getTokenURI(tokenId);
        string memory _baseURI = baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(_baseURI).length == 0) {
            return _tokenURI;
        }

        if(_isBlindBoxOpened){
            return _tokenURI;
        }else{
            return _baseURI;
        }
    }

    // change the NFT tokenURI
    function changeURI(uint256 tokenId, string memory uri) public onlyOwner {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        _setTokenURI(tokenId, uri);
    }

    // mint NFT to an account with the item URI
    function mintNFT(address recipient, string memory uri) public onlyOwner returns (uint256){
        require(checkWhiteList(recipient), "ERC721: Minting for non-whitelisted account");

        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, uri);

        return newItemId;
    }

    // check if a wallet account is in the whitelist
    function checkWhiteList(address acct) private returns (bool) {
        for(uint i=0; i < _whiteListedAccounts.length; i++){
            if(acct == _whiteListedAccounts[i]) return true;
        }

        return false;
    }

    // get the whitelisted accounts
    function getWhiteListedAccounts() public view onlyOwner returns (address[] memory) {
        return _whiteListedAccounts;
    }

    // add new account to whitelist
    function addWhiteListAccount(address acct) public onlyOwner {
        require(!checkWhiteList(acct), "ERC721: Account is already in the whitelist");
        _whiteListedAccounts.push(acct);
    }
}