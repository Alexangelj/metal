# metal

===================================

Our Eth Denver project -> Gamify ethereum ecosystem engagement.
Level up, earn cards, badges, collectibles, proof of attendence, etc. 
Ex. Level 1: Own 100 Dai
    Level 2: Own 100 cDai
    Level 3: Own an NFT
    etc.

Architecture:
    Main contract ->
        func daiReward:
            assert user bal >= num (100)

We can abstract the reward as an object and have one function to verify it.