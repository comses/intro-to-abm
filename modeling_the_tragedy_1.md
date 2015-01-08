# Modeling the Tragedy (1)
We present a simple model where agents harvest from a common resource without restrictions. We will see that this leads to an overharvesting of the common resource. There are number of tweaks to the model, which introduces some new primitives again.

First we model the resource. Not every cell has the same carrying capacity. First we set a percentage percent-best-land of the cells at the maximum carrying capacity. This is the best land in the landscape.
```
ask patches
[
  set max-resource-here 0
  if (random-float 100.0) <= percent-best-land
  [
    set max-resource-here max-resource
    set resource-here max-resource-here
  ]
]
```
The 10 iterations are used to smooth the resource values some more, leading to the spatial configuration as in Figure 3.
```
repeat 10
[
  diffuse resource-here 0.25
]
```

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_9_Fig_3.png)<br>*
Figure 3: Spatial configuration of the resource on the landscape. Lighter colors refer to higher levels of the resource.*

The agent looks to the north, east, west and south patch. For each direction it will look a number of patches ahead according to its vision and gives, as an answer, the resource level of the patch with the highest resource level. The agent then determines which of the neighboring directions has the highest level of the resource. If there is more than one neighbor with the highest resource level one of them is drawn at random. The agent then turns toward the best neighboring patch and makes a step forward.

Each tick the agent will harvest as long as the patch has more than one unit of the resource available. The resource will regrow using a logistic equation using a regrowth rate of 1% per tick. Figure 4 shows the results when agents take resources whenever they are available. These greedy agents lead to a collapse of the resource.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_9_Fig_4.png)<br>*
Figure 4. Resource size over time for the greedy agents.*

If we include a norm that agents will not harvest if the resource is below a certain level we may derive a more sustainable outcome. We assume that agents will not harvest a resource when it drops below 1 unit, or less than 50% of the carrying capacity of that cell. The maximum growth rate happens with a resource level of 50% of the carrying capacity. Hence if agents follow the norm they will receive a maximum return in the longer term. This outcome is often called the [maximum sustainable yield](http://en.wikipedia.org/wiki/Maximum_sustainable_yield).
Suppose we have the logistic growth equation for resource X:
```
X[t+1] = X[t] + r * X[t] * (1 – X[t]/K) – H[t]
```
Where H[t] is the harvest at time step t, r is the regrowth rate and K is the carrying capacity. In the long term, the sustainable solution is to harvest each time step the same amount as the resource generates. This means that
```
H = r * X * (1 – X / K)
```
If X is equal to 0, meaning a collapse of the resource the harvest level is 0. The other equilibrium is when X is equal to 0.5 * K. This is derived by taking the derivative of rX(1 – X/K) and set it equal to 0.

Figure 5 shows the result is the norm of 50% of the carrying capacity. We see that the resource is not collapsing but stays at a steady level.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_9_Fig_5.png)<br>*
Figure 5: Resource size over time for the norm-obeying agents.*

What if agents can imitate the behavior of others? We assume that agents imitate norms used by other agents who have greater wealth than themselves. The bigger the difference the more likely that an agent will copy the behavior of the other agent. Wealth is defined as the discounted sum of earnings of the past. Each tick past earnings are multiplied by 0.95 meaning a discount rate of 5%. This means that recent earnings have a higher weight than earnings far in the past.

If agents imitate the norms of others perfectly, and all agents start with the same norm of 50% of the carrying capacity, we will not see any differences compared to Figure 3. Although some agents may earn more than others, there is no diversity of traits.


