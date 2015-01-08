# Example Models
In this book we will use models to study complex adaptive systems. You will learn how to develop such models in Netlogo. Netlogo is a modeling platform developed by [Uri Wilensky](http://ccl.northwestern.edu/uri/) and his team at Northwestern University, and can be downloaded for free at http://ccl.northwestern.edu/netlogo/. We will use Netlogo version 5.0 for the examples in this book.

To get an idea of the types of models we are looking at during the course you can explore the large Netlogo Model library. There are many examples of various topics. Before you learn the programming, you can play with the existing models. We discuss now two examples in more detail.

In Netlogo Model library under the heading Biology there is a model titled Ants that simulates the foraging of a colony of ants. The ant colony in the center has 3 lumps of resources in the neighborhood. In Figure 7 the purple circle is the colony, and the blue circles are food piles. The ants initially move randomly around until they find a food resource. If an ant finds a food resource, they return back to their colony leaving a trail of pheromones behind them. Ants walking randomly around may encounter pheromone trails, and they follow this in the direction away from the colony. The three food piles are at different distances from the colony. You will experience that the ants consume first the closest food pile and end with the most distant food pile. One can explore the dynamics of the foraging behavior by changing the number of ants, the rate at which an ant leave pheromones behind them, and the rate the pheromones evaporate.

[NETLOGO EXAMPLE: ANT MODEL](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/netlogo/Ants.nlogo)<br>*Model: Right click on the Link and Save it. Open Netlogo and Run it with NetLogo.*

Another example of emergence is flocking behavior. In the biology section of the model library of Netlogo you will find the model titled Flocking. The agents monitor the movements of other agents in their neighborhood. If they are too close (minimum separation) to their neighbors they turn their direction (max-separate turn) to increase the separation. If an agent is not very close to its neighbors it turns its direction in line with the neighbors (max-align turn) to decrease the separation (max-cohere turn). The result is that groups of agents emerge who move around in a group. The values of the sliders determine whether a large group of agents or smaller groups of agents emerge.

[NETLOGO EXAMPLE: FLOCKING MODEL](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/netlogo/Flocking.nlogo)<br>*Model: Right click on the Link and Save it. Open Netlogo and Run it with NetLogo.*




