# Model Structures
A NetLogo model, like [other platforms for agent-based models](http://en.wikipedia.org/wiki/Comparison_of_agent-based_modeling_software), consists of algorithms that produce a sequence of commands to calculate changes of the attributes of the agents. First a model needs to be initialized, which means that all attributes of agents and environmental variables are defined and have initial values. In NetLogo, people typically use the procedure “setup” to do this. When you look at one of the many demo models in the NetLogo library, you see the button “setup” in most interfaces. Clicking on that button initializes all the relevant variables of the model.

When a model is initialized the model continues by calculating the updates of the attributes of the agents and the environment. This is typically started by clicking on the button “go” in the interface.

When you click on “go” you start a sequence of calculations. A model can be described as follows:
```
F(x,p)t =F(x,p)t-1
```

where F is a model, x the state variables of the model, and p the parameters of the model. The subscript t refers to the time step during the simulation, and F(x,p)o is the initialized version of the model.

Most models are built up on many different procedures. Procedure f may call procedure g and h. An important aspect of simulation models is the sequence in which procedures are called and thus the order in which variables of the model are updated. Suppose you have procedures *die, eat* and *metabolism*. Suppose you first call the procedure *die* to check whether the agent has sufficient energy. If not enough energy is available, the agent is removed from the model. Then the procedure *eat* is called, and the remaining agents derive more energy, before the procedure *metabolism* is called. Compare this sequence, with the case where first the procedure *eat* is called, then *die* and finally *metabolism*. You can tell that the order in which the agents are updated affect which agents remain in the model. Hence, the sequence in which you call the procedures is important.


The scheduling is not only important for the order in which you call procedures, but also the order in which you update the agents. Suppose you always update agents in the same order and they have to look for resources. Then the first agent has an advantage in finding available food, while the last agent may always experience a scarcity of resources. Such a fixed order leads to artifacts in the model. Therefore you see that the order in which agents are updated is typically random. When in NetLogo you call ask agents [], agents are updated randomly.
