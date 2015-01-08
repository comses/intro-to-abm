# Foraging
The basic foraging model that is introduced in this section assumes that the agents move around in the landscape without a memory and exchange information with other agents. Agents stumble on resources and consume them.

The movement is modeled as follows. Agents move on in the direction they were moving with a probability `probcont` and otherwise change their direction. Every step agents also consume energy through their metabolism. This is modeled in the following way.
```
if random-float 1 > probcont [rt random 45 lt random 45]
fd 1
set energy energy – metabolism
```
Like the model in the previous chapter, agents die when no energy is left, and reproduce when their energy level surpasses a threshold.

Figure 3 shows a typical simulation run. When we start with 100 agents, the population grows to about 400 agents. When we vary the level of uncertainty (`pmove`) we don’t see a change in the results. This is not surprising. Agents move around without specific directions and come across resources by accident. Including a more variable landscape of resources will not affect the results.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_7_Fig_3.png)<br>*
Figure 3. Population level over time for a typical run of the model.*


