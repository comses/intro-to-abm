# First Steps with NetLogo
How do you learn to use NetLogo? First, you can follow the YouTube tutorial. Second, you can explore the large number of existing models in the NetLogo model library. You can explore the behavior of a model by running the model for different assumption, such as different values of parameters. Lets use the example of the Rabbits Grass Weeds model in the model library (File – Models Library – Biology).

In this model rabbits move freely around on the landscape and consume weeds and grass. The rabbits have a metabolism of say 0.5 energy units every time step. By eating grass and weeds the rabbits derive new energy. When the accumulated energy of an agent is above the birth-threshold, the agent will generate offspring. Generation of a child is implemented as adding a clone of the agent in a nearby cell, and providing half the energy of the parent to the cloned child. As a result the number of rabbits in the population evolves over time, as well as grass and weed, which reappear by a fixed chance on an empty cell.

![rabitsgrassweeds](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/CH_4_Fig_1_RabbitsGrassWeeds.png)<br>*Figure 1: NetLogo Interface of the Rabbits Grass Weeds model*

<br>

![rabitsgrassweeds3D](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/CH_4_Fig_2_RabbitsGrassWeeds3D.png)<br>*Figure 2: Example of a 3 dimensional view of the Rabbit Grass Weed model.*

The basic user interface includes the “Interface” which gives the graphical output of the model (as depicted in Figure 1), the “Info” which provides the background information of the model, and “Code” which provides the source code of the model. The basic interface as depicted in Figure 1 shows more components. A few are important to mention: “File” provides the option to save the model, start a new model, or find a model in the model library. “Tools” include a number of helpful tools like “Shapes editor” to select a shape to represent an agent, “BehaviorSpace” to run a large number of simulations and store the results in a data file, and “3D view” which allows you to visualize the model output in 3D (Figure 2). “Help” includes a useful link to the user manual. In the detailed user manual there are discussions on a number of sample models, as well as helpful tutorials that go through the basics of NetLogo. The manual also includes detailed information on how to develop the interface as well as programming guidelines. Finally, the manual includes a number of tutorials on the use of features like “Shape Editor,” “Behavior Space,” “Sound” and “System Dynamics.”


To use the interface in Figure 1, you click on Setup, which will run the command to initialize the model. After this you can click on “go” to run the model. You can change the parameters during the simulation and see directly the effects.

