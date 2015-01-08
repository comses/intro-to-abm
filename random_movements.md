# Random Movements
There are different ways to model movement of agents on a landscape. Hereby we present a simple movement model and show the consequences of different assumptions.

The model is as follows. An agent moves straight with probability ps and if it does not move straight it will turn right with a random number of degrees and it will turn left with a random number of degrees (D). Thus, there are 2 parameters that define the movement.

The basic code in NetLogo looks like.
```
ifelse random-float 1 < probstraight [
  fd 1
][
  rt random degrees
  lt random degrees
  fd 1
]
```
Different values of D and ps lead to very different behavior. In the table below you see 9 possible patterns. If D is 20 and ps the agent is mainly moving straight making small adjustments. If D is 360 and ps the agents is moving around randomly in a small area.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_6.png)<br>*Figure 6.*

[NETLOGO EXAMPLE: RANDOM MOVEMENT](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/netlogo/ch5-3-movement.nlogo)<br>*Model: Right click on the Link and Save it. Open Netlogo and Run it with NetLogo.*

