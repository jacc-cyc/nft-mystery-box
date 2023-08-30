1. Install truffle globally

    ```shell
    $ npm install -g truffle
    ```

2. Install the dependencies 

    ```shell
    $ npm install
    ```

3. Create .env file and set the MNEMONIC environment variable (your wallet's mnemonic phrases)

    ```shell
    MNEMONIC=YourMnemonicPhrases
    ```

4. Add the below function to "@openzeppelin/contracts/token/ERC721/ERC721.sol"

    ```shell
    vim node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol
    ```

    ```shell
    function getTokenURI(uint256 tokenId) internal view returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        return _tokenURI;
    }
    ```

5. Compile the contracts 

    ```shell
    $ truffle compile
    ```

6. Deploy the contracts to Polygon Mumbai testnet. Network ("matic") is pre-defined in truffle-config.js

    ```shell
    $ truffle migrate --network matic
    ```

7. Interact with deployed NFT contract in the Polygon Mumbai testnet

    ```shell
    # Enter the testnet console. Network ("matic") is pre-defined in truffle-config.js
    $ truffle console --network matic

    # Create contract instance
    truffle(matic)> let nft = await NFT.deployed()

    # Mint the NFT with receiver's wallet address and NFT's URI
    truffle(matic)> await nft.mintNFT("walletAccount", "tokenURI")

    # Return the contract address
    truffle(matic)> nft.address

    # Return the token name and token symbol
    truffle(matic)> nft.name()
    truffle(matic)> nft.symbol()

    # Check NFT's URI with its unique token id (increased by one for each NFT, e.g. 1,2,3 ...)
    truffle(matic)> nft.tokenURI(id)

    # Set the boolean value of the blind box (true / false), true for open and false for close
    truffle(matic)> await nft.setIsBlindBoxOpened(boolean)

    # Return the current boolean value of the blind box (true / false), true for open and false for close
    truffle(matic)> await nft.getBlindBoxStatus()

    # Return the array of whitelisted accounts
    truffle(matic)> await nft.getWhiteListedAccounts()

    # Add a new account to the whitelist
    truffle(matic)> await nft.addWhiteListAccount()

    # Change the NFT's URI to a new URI with its unique token id
    truffle(matic)> await nft.changeURI(id, newTokenURI)
    ```

8. Go to below link, choose Mumbai testnet and import the NFT contract address (Step 7, # Return the contract address) to OpenSea testnet<br>
https://testnets.opensea.io/get-listed/step-two

sample image:
ipfs://QmdCgsBoMG5kKhpPD64xzqsejeg4H7SLEqdaYCrBh8wxZJ
