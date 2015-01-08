# Financial Bubbles
The price of a stock on the financial market represents the expected value of the company, which depends on the expected returns in the coming years. If everybody has the same information and all relevant information is public you would expect that the price would reflect the true value of the firm. Some people might be a bit optimistic and others a bit pessimistic, which may lead to trade of the stock. But as long as individuals don’t have foreknowledge there is no reason to expect that the price does not represent something other than the true value.

However, this is not what we see with actual financial markets, which can experience dramatic “mood” swings leading to major fluctuations in price. The reason that this happens is due to what is called herding behavior (link is external). People start to imitate the actions of others and sell when others sell, not because of individual price expectations, but because opinion on the quality of a financial asset changes due to interactions with others. When we get clusters of similar opinions this may lead to bubbles.

Each patch represents a trader who has a position on the market who may want to buy or sell a stock. If the position is -1 the agent wants to sell, and if the position is 1 the agent wants to buy. In the traditional model the position is influenced by white noise `random-normal mean-pnoise stdev-pnoise,` which leads an average of 50% of the agents to be positive and the others to be negative. This will lead to a kind of random walk. We implement this in the following way.
```
ask patches [
  ifelse ((random-normal mean-pnoise stdev-pnoise) > 0)
  [
    set trader-position 1
    set number-of-shares number-of-shares + 1
  ][    [
    set trader-position -1
  set number-of-shares number-of-shares – 1
  ]
]
```
The price goes up if there is a net sum of buyers and goes down if there is a net sum of sellers. Since the market is assumed not to be perfect, some noise is added to the price. In the results below we assume that `mean-noise` is equal to 0 and `stdev-noise` is equal to 0.25.
```
set price-converter 0.001
set returns sum [trader-position] of patches * price-converter
set noise random-normal mean-noise stdev-noise
set log-price (log-price + returns + noise)
```
Figure 4 shows how the positions of buying and selling are distributed in the landscape. The pattern is very much like a random distribution.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_10_Fig_4.png)<br>*
Figure 4. Map of the positions of traders. Red is selling and green is buying.*

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_10_Fig_5.png)<br>*
Figure 5. Price development over time.*

When people are influenced by their neighbors we will get herding behavior. We model this herding behavior by having agents take into account the positions of their four neighboring traders, north, east, west and south. The sum of the positions is weighted by A. Thus if the neighboring agents have a selling position, with a high value of A the agent will also have a selling position. A is assumed to be agent-dependent and drawn from a normal distribution with mean 0.5 and standard deviation 0.25 in the results below.
```
ifelse ((A * sum [old-position] of neighbors4 + random-normal mean-pnoise stdev-pnoise) > 0)
```
Note that we have to check the `old-position` of the neighboring agents if we assume sequential updating of the information.

Figure 6 shows the spatial distribution of herding agents. We see now pockets of red and green agents. This leads to mood swings in the market. Figure 7 shows the price fluctuations on the market, which are much more extreme compared to the modest price fluctuations in Figure 5. Prices go up for a while leading to a bubble and can then experience a dramatic collapse. Note that the equilibrium price is 4.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_10_Fig_6.png)<br>*
Figure 6: Map of sellers and traders with herding effects.*

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_10_Fig_7.png)<br>*
Figure 7. Price development over time.*

[image](https://www.openabm.org/book/33102/103-financial-bubbles)
___
Note for OS X users: The Google Chrome browser is unable to run the Java applets that enable NetLogo models in the browser. You must use the Safari or Firefox browser. Otherwise, you may download the model code and run it using the NetLogo application installed on your computer.
___
[Attachment](https://www.openabm.org/files/books/3443/ch10-herding.nlogo)	Size
 ch10-herding.nlogo	16.25 KB
