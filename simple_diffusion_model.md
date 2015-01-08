# Simple Diffusion Model
We will now present a series of NetLogo models of diffusion processes. In the first model, we have agents walking randomly around. All agents are randomly placed in the environment. With a probability `probstep` an agent adjusts its direction and will move one step forward. All agents are white except for one who has the color red. Every time step an agent will check the frequency of agents with the red color in the patch the agent is staying. If the fraction of red agents is above the threshold `threshold` of the agent, a white agent will become a red agent. We will contrast the effect of each agent having a threshold equal to 0.5, and each agent having a threshold value randomly drawn between 0 and 1. To implement this in NetLogo we use the code below. `turtles-here` is the set of all turtles on the caller’s patch. By adding other the set will not contain the caller. If checks first whether `sum0 + sum1` is larger than zero to avoid division by zero. If the fraction of red turtles is higher than the threshold, the color of the agent will be red and will stay the same, white or red, otherwise.
```
let sum0 0
let sum1 0
ask turtles
[
  set sum0 count other turtles-here with [ color = white ]
  set sum1 count other turtles-here with [ color = red ]
  if sum0 + sum1 > 0
  [
    if (sum1 / (sum0 + sum1) > threshold)
    [
      set color red
    ]
  ]
]
```
With an initial density of 1% of red agents we see a slowly growing number of red agents (Figure 5). When the threshold values vary among the agents the diffusion is faster compared to the same threshold value for all the agents. This is illustrated in Figure 6 where the heterogeneous case has a smaller number of ticks to come to a diffusion of red agents compared to a homogenous threshold of 0.5. When there is heterogeneity there are innovators who are more likely to adopt the innovation when just one red agent is on the patch.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_12_Fig_5.png)<br>*
Figure 5. Spatial pattern of 10000 agents.*

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_12_Fig_6a.png)![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_12_Fig_6b.png)<br>*
Figure 6. The top figure shows the number of adopted agents for heterogeneous threshold values. The bottom figure shows the number of adopted agents for a fixed threshold value of 0.5 for all the agents.*

[image](https://www.openabm.org/book/33102/123-simple-diffusion-model)
___
Note for OS X users: The Google Chrome browser is unable to run the Java applets that enable NetLogo models in the browser. You must use the Safari or Firefox browser. Otherwise, you may download the model code and run it using the NetLogo application installed on your computer.
___
[Attachment](https://www.openabm.org/files/books/3443/ch12-dif-randomwalk.nlogo)	Size
 ch12-dif-randomwalk.nlogo	10.57 KB
