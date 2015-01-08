# Density Dependent Resource Growth
We assumed in the previous section that the resource units will always recover from an empty cell using a fixed replenishment rate. This is very unlikely with many resources. The more trees in an empty spot in a neighborhood, the more likely that seedlings will fall on this spot and a new tree will be generated. If there are no trees around, no new trees will regenerate. This is called density-dependent growth and it is a common mechanism in many ecosystems.

For the whole environment we can now expected a logistic growth. In fact, the model above is a spatially explicit version of the famous [logistic growth function](http://en.wikipedia.org/wiki/Logistic_function). Suppose the resource size is defined by X[t] for time step t. Then the resource size at time step t + 1 is defined as

`X[t+1] = X[t] + r * X[t] * (1 – X[t] / K)`
Where r is the regrowth rate and K the [carrying capacity](http://en.wikipedia.org/wiki/Carrying_capacity). In our environment above, K is 10,000, namely 10,000 cells. The highest regrowth rate will happen when half of the resource is available, meaning X[t]= 5,000 for K = 10,000. If r is equal to 0.1 the resource grows over time, as in Figure 7. This is the classic S figure of the logistic growth function.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_6_Fig_7.png)<br>*
Figure 7. Resource level of logistic growth model with r = 0.1 and K = 10,000.*

In a spatial model, the regrowth rate not only depends on the value of r, but also on how the resource is distributed spatially. To model this in NetLogo we may initially think about the following implementation:
```
ask patches [
  if pcolor = black [
    if random-float 1 < replenishment-rate *
      (count neighbors with [pcolor = green])]
      [set pcolor green]
  ]
]
```
This means that for every patch that has no resource, there is a probability that it will regenerate. This probability will be higher in relation to the number of the eight neighboring cells that have resource units.

However, this implementation is often affected by a typical error people make in agent-based models. The problem is the following: All cells are updated randomly, one by one. If you have an empty cell and this cell becomes a cell with a resource unit, this cell is no longer seen as empty by the next cell to be updated. This can lead to strange results since the order in which cells are updated affects the results. It is theoretically possible that an empty landscape with just one cell with a resource unit could lead to a complete recovery in one time step. This is an unrealistic representation.

So how to implement the regeneration of the cells where we only take into account the state of the cells at the start of the time step? We need to add an additional attribute to the patch that remembers the old state of the cell. Then we can correct the model in the following way.
```
ask patches [set oldstate pcolor]

ask patches [
  if oldstate = black [
    if random-float 1 < replenishment-rate *
      (count neighbors with [oldstate = green])]
    [set pcolor green]
  ]
]
```
With a replenishment rate equal to 0.01 we get the dynamics we observe in Figure 8. The resource and population numbers do not stabilize and keep going up and down. When there is a lot of food, the agents start to consume a lot and produce many offspring. This leads the resource levels to go down, making it harder for the agents to find food. Since their metabolism needs energy every time step, some agents will die. As a result, the population size falls, and fewer resources are eaten. This, in turn, leads to the rise of the resource.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_6_Fig_8.png)<br>*
Figure 8: Population and resource size for density-dependent regrowth of resource with regrowth rate equal to 0.01. (Note that food is resource size divided by 4 to have the numbers at a similar scale.)*

We can portray the dynamics of the population and resource in a so-called [phase diagram](http://en.wikipedia.org/wiki/Phase_diagram) (Figure 9). This shows the cyclical dynamics of the two variables leading the system to circle around in a confined area of the phase diagram, but never settle into an equilibrium.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_6_Fig_9.png)<br>*Figure 9: Phase diagram of population and resource with regrowth rate 0.01.*

When we increase the regrowth rate to 0.1 the population level circles between 2500 and 5500, but never stabilizes (Figure 10). The population does not die out. When the resource is low, agents die out and the resource recovers. However, most species do not reproduce by cloning, and we will explore the consequences of having two parents in the next section.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_6_Fig_10.png)<br>*
Figure 10: Phase diagram of population and resource with regrowth rate 0.1.*


