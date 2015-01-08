# The Effects of Mating
Suppose agents can only reproduce when two agents meet who have energy beyond the minimum level of energy. Such a rule will imply that not all agents with more energy than the `birth-threshold` will get offspring. They have to find the right mate.

To implement this, an agent who has the minimum level of energy required for producing offspring needs to look around and check whether there is an agent nearby with sufficient energy. The primitive `in-radius` gives the set of agents that are found within a radius of a defined size. Thus `turtles in-radius search-radius with [energy > birth-threshold]` is the set of agents in radius of size search-radius who have more energy than the minimum amount of energy needed to produce offspring.

We only want to move on if there are any agents that meet this condition. Thus before moving on we use primitive any?, which checks whether there are agents within the agent set, and thus
```
if any? turtles in-radius search-radius with [energy > birth-threshold]
```
Now there is another problem. The agent who is looking for a mate is included in the agent set since it is an agent within the search radius. We have therefore to find a way to exclude the agent who is searching for a mate. Therefore we check what the identity is for the agent looking for a mate and exclude this from the list of agents that become a mate
```
let agentwho who
if any? turtles in-radius search-radius with [energy > birth-threshold and who != agentwho]
```
So, at this point we have a set of candidate mates. The agents are not very picky. We assume they skip speed dating and just accept any mate that meets the minimum conditions. Hence to select the mate we take one agent of the set of candidates. The number of candidates might be one, and then that one is chosen. But if the set is larger than one, one agent is randomly selected.
```
let mate one-of turtles in-radius search-radius with [energy > birth-threshold and who != agentwho]
```
We assume that initial energy of the child is 10% of the combined energy of the two parents. Each parent contributes an equal share to the energy of the offspring. This is implemented as:
```
let childenergy (energy + [energy] of mate ) / 10
set energy energy - 0.5 * childenergy
ask mate [set energy energy - 0.5 * childenergy]
  [ hatch 1 [set energy childenergy] ]
  ```
When we run the model with regrowth rate equal to 0.01 and a search-radius of 1 we get the phase diagram of Figure 11. The amplitude of the cycle is a bit larger than Figure 9, without mating. What is the reason for this?


![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_6_Fig_11.png)<br>*
Figure 11: Phase diagram for population and resource size with mating.*


