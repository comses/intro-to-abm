# Accidental Millionaire
Can you become a millionaire by chance? Here we show a simple model suggesting that it is possible. Suppose that there are 10,000 agents who make guesses whether the stocks will go up or down. Each round they make a guess by flipping a coin. The stock market goes up and down and its direction is also determined by flipping a coin.

When agents make a guess, they pay a price p to the pool x. The agents who correctly predicted the direction of the market will get an equal share of the pool.

How do we implement this model in NetLogo? Each tick the agents first pay a fee to the pool and determine their guess by flipping a coin. Flipping a coin is modeled by random 2, which provides values 0 and 1 with equal probabilities.
```
ask turtles [
  set earnings earnings - price
  set guess random 2
]
```
The size of the pool is equal to the fee times the number of agents. Whether the stock market goes up is determined by flipping a coin.
```
let pool nr-agents * price
set stockmarket random 2
```
Now for all agents we check whether their guess coincides with the direction of the stock market, if so, the agent has a correct prediction.
```
ask turtles [ifelse guess = stockmarket [set correct? 1][set correct? 0]]
```
Those agents who correctly predicted the direction of the market earn an equal share of the pool. We test whether the number of agents who made correct predictions is larger than zero to avoid the unlikely possibility that we divide by 0, which is not allowed.
```
let poolshare 0
if (count turtles with [correct? = 1] > 0) [set poolshare pool / count turtles with [correct? = 1]]
ask turtles [
  if correct? = 1
  [set earnings earnings + poolshare]
]
```
So what is the outcome we can expect? On average the earnings will be zero. There is no money coming into the system. As we can see in the simulation of 10,000 agents after 100,000 ticks, the distribution looks like Gaussian distribution

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_4.png)<br>*Figure 4.*

However, if we look at the maximum earnings of agents in the population, we see that this maximum keeps going up. In fact it looks like one of the agents is very lucky and earns a high amount.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_5.png)<br>*Figure 5.*

[NETLOGO EXAMPLE: RANDOMNESS](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/netlogo/ch5-random-v1.nlogo)<br>*Model: Right click on the Link and Save it. Open Netlogo and Run it with NetLogo.*

