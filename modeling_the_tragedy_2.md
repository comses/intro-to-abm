# Modeling the Tragedy (2)
We now introduce that agents may make errors in reading the norm that others use. If they imitate, they imitate the norm used by the other agent, but we will add a noise term to it. The errors in imitation may lead some agents to start using a norm above 50% and others below 50%. Over time we see that the norm will drive towards 0% and the resource will be depleted as shown in Figure 6.

How do we interpret this result? Agents are willing to obey norms of sustainable use of the resource but will adjust their strategy if they see that others do better by not obeying the norm. In the model all agents had good intensions, yet just by imperfect copying we get a crowding out of the moral norms of sustainable use of the resource. Hence good intensions are not sufficient for a sustainable use of the resource.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_9_Fig_6.png)<br>*
Figure 6. Resource size over time for norm-obeying agents who imperfectly imitate better performing agents.*

We now include the option that agents can give each other a warning. For a small cost one agent can reduce the earnings of another agent who is caught breaking the norm. In the least, an agent can sanction those who harvest when they would not harvest. A third agent can also then sanction the first agent, if that agent breaks the norm that the third agent was assuming.

Each turtle will check which agent in its vision has the lowest `harvestedlevel` used. The `variable harvestedlevel` is calculated in `harvest` by dividing `resource-here` by `max-resource-here.` The primitive `in-radius` defines a radius of size `radius` around the agent.
```
let otheragent min-one-of turtles in-radius radius [harvestedlevel]
```
When there is another agent in the radius, the agent checks whether this agent uses a lower norm than itself. If so it will punish the agent and reduces its wealth with `costpunished,` at a cost of `costpunish` to itself. Agents are not allowed to punish if their wealth is not more than `costpunish`
```
if otheragent != nobody [
  if [harvestedlevel] of otheragent < norm-min-resource [
    set wealth wealth - costpunish
    ask otheragent [set wealth wealth - costpunished]
  ]
]
```
When an agent gets punished so frequently that its wealth drops below 0, we replace it with the norm of a random other agent and put its wealth equal to 0. Figure 7 shows that the resource diminishes slowly if agents use peer punishment. The `radius` used is 10, the `costpunish` 0.01 and costpunished 0.1. The level of punishment is relatively high. It is more than a verbal warning or a slap on the hand. We will explain below why this was needed.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_9_Fig_7.png)<br>*
Figure 7: Resource size over time for simulation with punishment.*

Figure 8 shows the average level of the norm. On average the norm slowly declines below 0.5. However, if we look at Figure 9 where the avatars are sized to the norms they use, we see a huge variability. Some agents are very greedy and collect whenever they want. The punishment they may receive from others is not sufficient to stop them.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_9_Fig_8.png)<br>*
Figure 8: Norm-min-resource on average of the agents over time for punishment simulation.*

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_9_Fig_9.png)<br>*
Figure 9: Avatars of agents sized to the level of the norms agents use.*

One of the challenges is to anchor the norm to the sustainable level. The agents use informal norms and they may forget the sustainable norm they originally started with. How do we maintain the memory of the agents? One option is to start having formal rules that state clearly what the official allowable levels of resources may be. Furthermore, the sanctioning level might not be the same for everybody. Agents who persist in breaking the rule may get higher penalties. This is what we call graduated sanctioning. The first time agents break a rule, they get a warning, and over time they get higher and higher sanctions. You may adjust the model to include those aspects and see whether you get a sustainable outcome.

[NETLOGO EXAMPLE: HARVESTING RESOURCES](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/netlogo/resourceharvest.nlogo)<br>*Model: Right click on the Link and Save it. Open Netlogo and Run it with NetLogo.*

