# NFTsurance

A neat lil contract that provides decentralized insurance (more like covered call options) for NFTs.

InsuranceNFTs (ERC1155s) are minted from the contract and envisioned be sold on some options market place (perhaps OpenSea becomes an options marketplace? haha)

Insurance allows owners of the InsuranceNFTs to burn their InsuranceNFTs and send the same number of the NFTs which the insurance insures to the insurer. In return, the get a payout in a previously specified token for each NFT they send.

This isn't really usable because the insurance isn't pooled, so a wealthy insurer would have to mint a ton of insurance for this to really be usable on a large scale. Pooled insurance would be possible with NFT price feeds from an oracle, which, from my cursory reasearch don't exist.

The only place where this something this fragmented would be cool to use would be insuring NFT drops. If you mint, and the project was insanely overhyped and the floor crashed for some reason, people could just mint/buy insurance for small projects. Idk