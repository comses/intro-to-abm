# Policy Intervention
In order to stop the spread of infectious diseases we have a number of options. We can vaccinate people if a vaccine is available. Another option is to reduce the interactions between agents. In practice, schools are often closed during an outbreak of a virus since children are an effective host in the spread of diseases like the flu. With sexually transmitted diseases like AIDS, targeting prostitutes is a common approach since they are the hubs in interactions between agents. As an exercise we implement the option of deactivating an agent by clicking them with your mouse. Run the model and see whether you can isolate the virus (Figure 5). As you can see this is not an easy approach.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_13_Fig_5.png)<br>*
Figure 5: Screenshot of network where user tried to isolate virus (red nodes) by deactivating nodes (blue).*

Another approach is to deactivate the links with the highest degrees. To model this in NetLogo we create a while loop and every iteration we find one of the turtles that has the most neighbors and has not been isolated yet. We then isolate that agent. When an agent is isolated we give them the color blue.
```
let i 0
while [i < numberofisolatedagents]
[
  let target max-one-of turtles with [color != blue] [count link-neighbors]
  ask target [
    set infected? false
    set resistant? true
    set color blue
  ]
  set i i + 1
]
```
We simulate the model 1000 times for different numbers of agents to be isolated and we see that more agents are not getting sick. What is the benefit of isolating a person? In Figure 6 we show that for each isolated person on average one or two other persons are spared. However, after isolating 80 agents the marginal benefit start to decline.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_13_Fig_6.png)<br>*
Figure 6: The rate of return (reduced number of infections – isolated agents, divided by the number of isolated agents).*

Looking at an example of what the strategy is doing (Figure 7) we see that isolating the agents with the highest degrees is not necessary since it is, in effect, isolating agents far away from the infection. Furthermore, it does not isolate the spread of the disease.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_13_Fig_7.png)<br>*
Figure 7. Screenshot of network with 50 isolated agents.*

Of course it would be the most effective strategy to isolate the nodes next to the infected agents, but that would not be a fair strategy, since the computer is as fast as the speed of light unlike actual policies.

Suppose that we can isolate one agent each tick, which agents would we want to isolate. We can choose one agent with the highest degree each tick within a radius X of turtles who are infected. A smaller radius would indicate that the controller who is isolating agents has better information on where infected agents are. Not surprisingly, we see that a short distance leads to better performance (Figure 8). But not too close, however, since there might not be a sufficient number of highly connected nodes in a small radius that could stop the spread. Figure 8 also shows that more than 50 isolated agents starts giving less effect per isolated agent.

Although agents are not isolated at the start of the simulation, the performance is much better than isolating agents with a high degree at the start of the simulation.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_13_Fig_8.png)<br>*
Figure 8. Average rate of return in isolating agents when different radius distances and a different number of isolated agents are used.*


