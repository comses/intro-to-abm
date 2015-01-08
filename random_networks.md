# Random Networks
Let’s start with looking at a simple network, the random network. In this network there is a population of n nodes. One by one we add links between nodes. We do this by randomly picking one of the nodes, and linking them randomly with another node.

In the Netlogo code, you see that adding a random link is done as follows. Pick two turtles and check whether there is already a link between them. To do this we make use of `link-neighbor? X,` which is a primitive that is true if there is a link between the turtle and X. If there is no link already we can create a new link between the two turtles using `create-link-with X.`
```
to add-edge
  let node1 one-of turtles
  let node2 one-of turtles
  ask node1 [
    ifelse link-neighbor? node2 or node1 = node2 [add-edge]
    [ create-link-with node2 ]
  ]
end
```
In Figure 5, you see how the network is visualized during the construction of links. The red links and turtles are the largest connected component of the network.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_11_Fig_5.png)<br>*
Figure 5 Creating a random network.*

We can visualize the relative size of the biggest component over time (Figure 6). Initially the size is very small, just a few turtles. Then there are jumps, as small components get connected. It takes a while until all turtles are connected.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_11_Fig_6.png)<br>*
Figure 6. The fraction of the biggest component of connected turtles as part of the whole network. The vertical line is the moment in time where there are as many links as turtles.*

Not all turtles have the same number of links (Figure 7), but they will each have a minimum of 1, since the model ran until all turtles were connected. In the example simulation we see that the number of links varies from 1 to 12. The median degree is 4. The clustering coefficient is 0.054 and the average path length is 2.96 links.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_11_Fig_7.png)<br>*
Figure 7. The distribution of degrees in the example run.*

[NETLOGO EXAMPLE: NETWORKS](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/netlogo/networks.nlogo)<br>*Model: Right click on the Link and Save it. Open Netlogo and Run it with NetLogo.*
