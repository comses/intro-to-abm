# Diffusion in Social Network
Suppose agents are connected within a social network, like a small-world network. Starting with one red agent, white agents who have a red neighbor will adopt the innovation. This leads to the spread of the innovation through the network. As you can see in Figure 7, the diffusion takes short cuts of relinked nodes. The shorter the average path length in a network, the faster the innovation will spread.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_12_Fig_7.png)<br>*
Figure 7. Snap shot of spread of innovation on a small world network.*

To model the diffusion in networks we count for each node the number of friends that are red. All agents are updated synchronously. Therefore we first define the number of red friends for each node, and then check whether the threshold is passed. Check out what happens if the updating is not synchronous. The basic code of the model is now as follows.
```
ask turtles [
  let node1 self
  set nan count turtles with [link-neighbor? node1 and color = red]
]
ask turtles [
  if nan >= threshold [ set color red]
]
```
In Figure 8 some simulation runs are provided for a network of 500 nodes with different rewiring probabilities. There is one red agent at the start of the simulation. We see that when all agents are in a circle—-no rewiring—-the number of red agents spread linearly until all agents are adopted. When there is a small probability of a rewiring, the adoption is also linear until the short-cut is hit, which speeds up the adoption rate. We see that for larger rewiring rates the diffusion goes faster.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_12_Fig_8.png)<br>*
Figure 8. Diffusion in networks with different rewiring probabilities.*

[image](https://www.openabm.org/book/33102/124-diffusion-social-network)
___
Note for OS X users: The Google Chrome browser is unable to run the Java applets that enable NetLogo models in the browser. You must use the Safari or Firefox browser. Otherwise, you may download the model code and run it using the NetLogo application installed on your computer.
___
[Attachment](https://www.openabm.org/files/books/3443/ch12-dif-network.nlogo)	Size
 ch12-dif-network.nlogo	21.39 KB

