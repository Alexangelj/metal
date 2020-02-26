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




Layer 2 scaling - i.e. Plasma ->> Done, next idea...

Ethereum is a network, you transact on the network and pay gas. What if there was mini network?
Mini network has native token to pay for tx finality like 'gas'. Tx's eventually go up to the ethereum mainnet,
but in batches, so you get much higher tps. 
Big network effects. Other entities could use mininetwork if they need lots of tx's, like digital game items.

Can it be done though?

Lets go through how it'd work.
Ethereum tx updates a state of a contract. So that contract's state would need to hold all the mini network info, very dense probably.
The mini tx's could update state within the contract as indeterminates, and then broadcast when a threshhold is met?



Entangled ERC-20 Tokens on Ethereum -> Set Tokens Already done it! Next Idea...


You have two tokens, i.e. DAI and rDAI. 
Transferring the balances of both those tokens requires two transactions at least, 
what if it could be one tx? This saves gas.


Going further, rDAI accrues interest while Dai is a stablecoin.
If you combine 1 + 1 rDai and Dai you get total principle of 2, 
with half of the principle accruing interest.


Going further, you have 1 rDai accruing 5% fixed interest and 1 cDai accruing 4% variable interest.
Entangling the two assets produces 2 principle with 5% fixed + 4% variable interest.
To that effect, you are spreading the risk of the interest rate changing between two seperate but probably correlated assets.


Okay, further! You have some wrapped eth, 6 wEth, and you like it as an asset but it's too volatile.
You want to keep some volatility in it, but not all, and you want to be long Eth. 
Basically you want a less volatile Ether. You can create this with entangled and I'll show you how.


Your 6 wEth gets entangled with 4 stEth. stEth is short Eth. 
Eth is $100 at the time of this entanglement, your position is $1000.
Eth moves to $80, bringing our wEth down to $80 and your stEth to $120
Your 6 wEth is worth 6 * 80 = 480,
Your 4 stEth is worth 4 * 120 = 480,
For a total of 480 + 480 = $960. 
Eth moved 20% while your position moved 4%.
Each stEth in this case reduced your long exposure by 4%, mitigating risk. 


How the hell does stEth work though? How can you be short eth? 
That's the second part of this protocol.
We can short stEth by making an agreement with a rational actor as follows:
If Eth goes below the price of $xxx, you will buy it at $xxx.
So, if Eth goes below $100, you will still buy it at $100.
Why would an actor do this? Shorting anything requires a premium paid.
This is the contract:
If Eth goes below $100 in the next 120 days, you buy it at $100, if it doesn't, you keep my $4 premium.
To you, the stEth owner, your $4 premium is worth it because of the volatility ($20 drop).
To the rational actor, the $4 premium is worth the risk that Eth goes below $100.


How does it work technically?
The rational actor deposits collateral to ensure they purchase the Eth at $100, 
they get to mint stEth, which they can sell for normal eth + premium.
This is a Put option in traditional finance.