# Pick Your Friends
The network approach discussed above is static and agents with different threshold values are connected with each other. Another approach would be for agents to find others like them who want to form a group to implement a public good. In this section we present a simple model of such a community-evolving process.

Agents are randomly allocated on the landscape. The agents make decisions to contribute to a public good or not. At least two agents need to be within a radius D in order to create a public good. The payoff from the public good is equal to

yi = 1 - xi + r∑j=1N xj

Where r is the marginal per capita return, y the payoff and x the investment in the public good. The public good game is played with agents within a radius D of the agents. This means that each agent has a different set of players.

When agents have interacted with the agents around them they will receive feedback on the attitude of the other agents. We assume that agents who are surrounded with agents where the level of cooperation is above threshold will stay around. If the level of cooperation of the other agents is lower than that threshold they will move away from the group. Agents who are tolerant, a low value of threshold, are more likely to stay.

This is modeled in NetLogo as
```
let otheragents other turtles in-radius dist
let numberofagents count other turtles in-radius dist
if numberofagents > 0 [
  let meandecision mean [decision] of otheragents
  set payoff payoff + 1 - decision + 0.6 * (meandecision * numberofagents + decision)
  ifelse meandecision > threshold [
    face one-of other turtles in-radius dist
  ][
    face one-of other turtles in-radius dist
    set heading heading + 180
  ]
]
```
When the threshold values are initially drawn from a uniform distribution we get the distribution of agents as shown in Figures 7 and 8. Agents with low thresholds start cooperating and attract other agents who only cooperate with higher thresholds. This leads to groups expanding. In the end all agents cooperate.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_15_Fig_7.png)<br>*
Figure 7. Agents colored according to their thresholds. Green is around 0.5, black around 0 and light green around 1.*

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_15_Fig_8.png)<br>*
Figure 8. Agents colored for their decisions. Black agents contributed, light blue agents did not contribute.

The agents in the example above did not evolve their thresholds. We will now include an evolutionary force. The fitness of an agent is assumed to be the average payoff per tick derived during its lifetimes. Each tick we will pick one agent from the population that has the lowest average payoff and we will replace that agent with an agent that has randomly drawn traits and threshold value and put it randomly on the landscape. We also add noise to the traits each tick. This means that the traits remain varying and do not get locked in into one particular value.

By removing the least successful agent each tick we get a population that becomes more similar and tolerant of differences of trait characteristics. We will get agents evolving to all cooperation again.

We will now add types of agents. The threshold-based agents are conditional cooperators. They only cooperate if x% of others cooperate too. In empirical research we find 2 other types of agents: the egoists who are always defecting, and the altruists who are always cooperating.

We start the simulation with 10% egoists and 10% altruists, and make the rest of the agents conditional cooperators. We see groups emerging initially started by some altruists and conditional cooperators with low thresholds (Figure 9). The groups can grow over time but since egoists are also attracted to groups of cooperators, groups can fall apart. Egoists entering the group lead some conditional cooperators to stop cooperating and leaving the group.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_15_Fig_9a.png)<br><br>![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_15_Fig_9b.png)<br>*
Figure 9: Clusters of agents with dist equal to 5 at the beginning of the simulation (top) and after 25,000 ticks (bottom).*

Figure 10 shows that the distribution of types of agents remains relatively stable over time, but the distribution of thresholds evolves to more tolerant agents. Conditional cooperators who only cooperate if everybody around them cooperates will not find a group that will lead them to gain a higher fitness. As such agents who are very picky will die out.

Play around with the model and see the different dynamics you get with different values of `dist` and with different initial distributions of the types of agents. You will see that the results are quite sensitive to the initial conditions.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_15_Fig_10a.png)![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_15_Fig_10b.png)<br>*Figure 10: Time series of the share of the types of agents (left) and the distribution of thresholds after 25,000 ticks. The colors in the left figure refer to egoists (red), altruists (green) and conditional cooperators (green).*

The model discussed is very simplistic with respect to the actual social complexity. We could add to the model that cooperative agents would punish freeriders so that egoists will comply with the norms in the community. The model can be extended by rules on when to enter or exit a group. The model simply assumes that everybody can join and leave. In practice it might be difficult to get people to join a group or to kick a defector out of the group. Hence this simple model can be extended in various ways to study questions on collective action.


[image](https://www.openabm.org/book/33102/154-pick-your-friends)
___
Note for OS X users: The Google Chrome browser is unable to run the Java applets that enable NetLogo models in the browser. You must use the Safari or Firefox browser. Otherwise, you may download the model code and run it using the NetLogo application installed on your computer.
___
[Attachment](https://www.openabm.org/files/books/3443/ch15-groups.nlogo)	Size
 ch15-groups.nlogo	14.58 KB
