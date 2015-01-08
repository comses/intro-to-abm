# Lock-in of Products
Why do we sometimes have one product dominating a market, even if it is a product that some argue to be inferior? Examples are [Microsoft](http://www.microsoft.com/en-us/default.aspx), [QWERTY keyboards](http://en.wikipedia.org/wiki/QWERTY), [Google](https://www.google.com/?gws_rd=ssl) search engine, etc. This is the problem of [lock-in](http://en.wikipedia.org/wiki/Vendor_lock-in). Economist [Brian Arthur](http://en.wikipedia.org/wiki/W._Brian_Arthur) (1994) studied the problem of lock-in of technologies and developed some models that simulates lock-in processes.

The basic idea is the following. Suppose there are two products to chose from, say Microsoft and Apple. The more people in your environment with whom you share files who use product A, the more valuable product A is. If a person has to make a choice between two products, he or she will be more likely to choose the product that has a majority of users, if the two products have similar performance.

We can implement this process in a simple model. Every time step agents made a choice. The choice for product A is proportional to the share of product A of both products as chosen in the previous time step. Starting the model with equal probabilities, one of the two products starts to dominate. Which product will dominate cannot be predicted from the start. Random events may give one of the products a larger market share and stimulating dominance in future time steps (Figure 9).

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_12_Fig_9.png)<br>*
Figure 9. Share of red product among agents who bought a product.*

In Figure 9 we show results of a model where every time step another agent will decide to enter to make a decision between product A and B. Every time step agents who have made a choice between A and B will reconsider it based on the current adoption shares. Suppose agents will not reconsider their decisions then we may get stable mixed shares of products A and B (Figure 10). Once a large number of agents have made their choice between A and B, every new agent will choose relative to the frequency of products A and B. Hence, we need to include some reconsideration of agents in order to derive lock-in of one of the products with certainty.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_12_Fig_10.png)<br>*
Figure 10. Share of red product among agents who bought a product when agents do not reconsider.*

In Figure 11 you see the results of a large number of simulations. We run the model for 1000 time steps, and use different probabilities for agents to reconsider their choices. For each probability 1000 simulations were performed and the fraction of product A was determined at the end of the simulation. Then we ordered the simulations according to the share of product A. We see that for a reconsideration probability of 0, the share of product A follows a uniform distribution. However, for probability equal to 0.02, one third of the simulations have a fraction of zero, and one third has a fraction of 1. Hence the distribution is bipolar.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_12_Fig_11.png)<br>*
Figure 11. Fraction of shares of product A at the end of 1000 simulations for different probabilities of agents reconsidering their choice.*

[image](https://www.openabm.org/book/33102/125-lock-products)
___
Note for OS X users: The Google Chrome browser is unable to run the Java applets that enable NetLogo models in the browser. You must use the Safari or Firefox browser. Otherwise, you may download the model code and run it using the NetLogo application installed on your computer.
___
[Attachment](https://www.openabm.org/files/books/3443/ch12-lockin.nlogo)	Size
 ch12-lockin.nlogo	11.25 KB
