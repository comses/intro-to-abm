# A Threshold Model of Collective Action
The first model is based on the work of sociologist [Mark Granovetter](http://en.wikipedia.org/wiki/Mark_Granovetter). He describes a situation in which 100 agents have different thresholds that determine whether they are willing to join a riot. Some agents will join the riot if a handful of others participate, while some will only join if most others participate. Suppose the distribution of the thresholds is such that there is one agent with threshold 1, one agent with threshold 2, etc., up to one agent with threshold 99. If one agent who has a threshold 0 initiates the process, we will see that all 100 agents will end up participating in the riot. The reason is as follows. When one agent starts making trouble, the agent with threshold 1 will join next which will lead to the agent with threshold 2 to join the riot.. The process will continue until the thresholds of all 100 agents are met.

Suppose the distribution of the thresholds is a bit different. Instead of the distribution {0 1 2 3 … 98 99} the distribution is {0 1 2 4 4 5 … 98 99}. What will happen? Indeed no more than 2 agents will participate in the riot.

A NetLogo model is developed to explore the consequences of different distributions. We will look at the distribution of riot sizes if the distribution is uniform between 0 and 99, and if the distribution is a truncated normal distribution with mean 50 and standard deviation 25.

Figure 3 shows the distribution of riot sizes for 1000 simulations. Although the average threshold is the same for both distributions, the resulting outcomes are very different. The largest riot size for the [Gaussian distribution](http://en.wikipedia.org/wiki/Normal_distribution) is 11, while there are dozens of all 100 agents with the uniform distribution. It is important to have sufficient agents who are easily triggered to participate.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_15_Fig_3.png)<br>*
Figure 3: Distribution of riot size for different distributions of thresholds.*

The thresholds we have used so far are all or nothing. An alternative way to model the thresholds is to define them as [probability functions](http://en.wikipedia.org/wiki/Probability_density_function). We define the probability that an agent will participate as follows

P[A] = Xα / (Tα + Xα )

Where P[A] is the probability of action, X is the number of agents already participating, T is the threshold of the agent and α is a parameter that defines the shape of the function. Figure 4 shows the probability function for T = 50 and α = 5 or 10. Figure 5 shows that the smoother the threshold the more likely that the whole group will join the riot. Still the Gaussian distribution of thresholds do not lead to many population size riots.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_15_Fig_4.png)<br>*
Figure 4. Probability distribution of participation with T = 50 for α = 5 (blue) and α = 10 (red).*


![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_15_Fig_5a.png)![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_15_Fig_5b.png)<br>*<br>*
Figure 5. Distribution of riot sizes for different probability functions using α = 5 (top) and α = 10 (bottom).

[NETLOGO EXAMPLE: GRANOVETTER MODEL](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/netlogo/granovetter.nlogo)<br>*Model: Right click on the Link and Save it. Open Netlogo and Run it with NetLogo.*
