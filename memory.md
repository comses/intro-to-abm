# Memory
What will happen if agents can remember locations where they found food before? If their energy level starts getting low, they may check the locations where they have been successful in the past. We can model memory in different ways, and we adopted a very simple way to model memory. Every time an agent eats a food item that holds more energy than a certain minimum level, the agent will mark that location and keeps it in memory. When the energy level of the agent is below a minimum level, the agent starts to look into its memory and goes to the location of opportunity that is closest to the current location of the agent. If there is no food at that location, the location will leave the memory of the agent.

To implement this in Netlogo we will use turtles to mark the locations. This will help us later to direct the agents to the locations. However, this causes a problem. Turtles can now be foragers and markers. In order to distinguish the different uses of turtles we will use the primitive `breed.` By defining different breeds of turtles you can create different types of agents with different attributes. To define a breed you provide the name of the breed when they are multiple or single like
```
breed [foragers forager]
breed [markers marker]
```
You can now define attributes of the foragers by using `foragers-own` and use ask for forager agents directly.

When we model that agents update their memory, they are creating a marker turtle and put the marker agent into the memory of the agent. This is implemented in the following way:
```
if item iter foodenergy > thresholdmemory [
let marked self
  hatch 1 [
    set breed markers
    set marked self
  ]
  set memory lput marked memory
]
```
Note that we use a temporary variable marked to create a variable that captures which turtle is the agent. The location of the marker agent is the location where the agent is at the moment of the creation of the marker agent. Memory is a list and we put the marker in the memory.

When agents are moving around and their energy level goes below a threshold `THusememory` we first check if there are any markers in the memory of the agent. By `length memory` we get the number of objects in the list `memory.` If there is no memory there is no need to use it. If there is a memory, we will go through the list of markers and check the distance between the agent and the location of the marker. `distance x` gives the distance between the current position of the agent and turtle x. The marker with the shortest distance will be chosen as the target to move to.

The primitive `face` is used to redirect the `heading` of the turtle towards the marker that is targeted. Thus if the agent is in need it turns its direction to the closest location in its memory of good opportunities.
```
if energy < THusememory [
  let sizememory length memory
  if sizememory > 0 [
    let i 0
    let mindistance 100
    while [i < sizememory]
    [
      let dist distance item i memory
      if dist < mindistance [
        set mindistance dist
        set target? true
        set target item i memory
      ]
      set i i + 1
    ]
    face target
  ]
]
```
When agents arrive at the location of the target we will remove the target from the memory whether there is food on the patch or not. How do we know whether the agent arrived on the patch? The distance between the agent and the target marker should be small. We could say that the distance is zero, but since agents are not always located in the center of the patch, we may end up with agents getting stuck since they are on the right patch but not exactly at the location of the marker.

To avoid agents getting stuck on a patch trying to find the right location we allow some marker of error. This is the reason we check whether the distance between the agent and the target marker is smaller than half a patch.

If the agent is near the marker we set `target?` on `false` since we arrived at the target. We also remove the target from the memory. To avoid getting a model with many ghost markers, which can make the model run very slow, we remove the marker turtle from the model by letting it `die.`

If there is no food on the patch, the agent will check its memory for another target. If the memory is empty the agent will move around in a kind of random walk as defined above. If the agent finds a patch that contains food a new marker turtle is generated and added to the memory.
```
if distance target < 0.5 [
  set target? false
  set memory remove target memory
  ask target [die]
]
```
If an agent gets offspring we need to take special care about the memory. The memory is assumed to be based on the experience of the agent. We assume that the parent does not pass its memory to its offspring. This could be a possible assumption, and we suggest exploring what the consequences would be. But suppose the newborn agents will be born with a blank slate. A clone of an agent will have its parent information on `memory,` `target?` and `target.` To erase the memory and target information from the clone of the parent agent we will define a hatched agent as below.
```
hatch 1 [
  set memory []
  set target? false
  set target nobody
]
```
Now we will run the model for different combinations of parameter values. We want to know what the effect is of having a memory. Furthermore, we would like to see whether the benefits of having a memory change according to the rule when agents use their memory and the kind of environment they live in.

In Figure 4 we see the results that occur when agents remember every location of successful food collection (`thresholdmemory` equal to 19).We see that the population size is higher than the baseline, which is the population level without memory. But the effect of memory varies on the context. Population size is highest when the environment is stable (`pmove` equal to 0) and when agents use the memory only when they are really hungry. A stable environment makes it more likely that memory actually makes sense. One should also not wait to the last moment (a low value of `THusememory`) to use the memory since it might be too late to extract find the resources on time.

We see that when agents use their memory very quickly, the benefit of the memory declines. The reason for this is that agents return to a location before the food item has been replenished. Since it takes 50 ticks for a food item to replenish, it makes sense to use the memory only if the energy level becomes really low. Otherwise agents walk around without being successful and forget about possible good locations.

Figure 5 shows the results that occur when the agents are really picky about which types of locations to remember. For instance, when they only remember those food items with the highest energy levels, the benefit of memory is very modest. In fact, most agents will not have anything in their memory since they have not experienced these high level resources.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_7_Fig_4.png)<br>*
Figure 4: Population size average of the last 5000 ticks for different parameter combinations and a `thresholdmemory` equal to 19. Different lines represent different values of `pmove.`*

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_7_Fig_5.png)<br>*
Figure 5: Population size average of the last 5000 ticks for different parameter combinations and a `thresholdmemory` equal to 99. Different lines represent different values of `pmove.`*

[NETLOGO EXAMPLE: FORAGING](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/netlogo/foraging.nlogo)<br>*Model: Right click on the Link and Save it. Open Netlogo and Run it with NetLogo.*
