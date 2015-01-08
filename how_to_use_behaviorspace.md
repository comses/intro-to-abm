# How to use BehaviorSpace
BehaviorSpace is a tool of NetLogo to automatically run a large number of simulations and collect the data that you are interested in in a text file and/or Excel file.

BehaviorSpace can be found in NetLogo under Tools. If you click on BehaviorSpace you will see the following:

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_13.png)<br>*
Figure 13*

Before we go further, it would be useful to get a model from the library so that we can run some experiments for an actual model. We will select PD N-Person Iterated from the NetLogo library. There you will find:

`Social science -> unverified -> Prisoner’s Dilemma-> PD N-Person Iterated.`


This model simulates a population of agents who, every timestep, are randomly partnered up with another agent to play a [prisoner’s dilemma](http://en.wikipedia.org/wiki/Prisoner's_dilemma) game. Each agent has a strategy. In the interface you can determine the amount for each of the 6 strategies. The strategy unknown is meant for you to try out new strategies. As a default it is a [Tit-for-Tat](http://en.wikipedia.org/wiki/Tit_for_tat) strategy.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_14.png)<br>*Figure 14.*

If you run the model, you will see that the strategies have different average payoffs in the longer term. Actually the defect strategy is found to give the highest amount of payoff.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_15.png)<br>*
Figure 15.*

Suppose we want to explore the results for a number of different distributions of strategies. Will defect always get the highest payoffs?

Instead of doing this manually, we will use BehaviorSpace. Go again to BehaviorSpace in “tools.” When the following screen pops up:

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_16.png)<br>*
Figure 16.*

click on “new.” We will now generate the settings for running an experiment. In the following figure we see that the global variables (including the sliders on the screen) are listed in the list of variables you can vary. The values given are the default values. We also see the number of *repetitions* we want to run the model for each parameter setting.

Then we see the information we will save in a text file or Excel file. As a default this is “count turtles.”

We can store information for each timestep or only the results at the end of the simulation (*Measure runs at every timestep*).

The setup commands define that the command *setup* will setup the model.

The go commands define that the command *go* will let the model run forever.

The time limit is the maximum number of ticks that we will allow the model to run.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_17.png)<br>*
Figure 17.*

Now we want to run a series of experiments by varying the distribution of agents. We will vary the variables in the following ways:

```
[“n-defect” 5 10]
[“n-cooperate” 5 10]
[“n-unforgiving” 5 10]
[“n-random” 5 10]
[“n-unknown” 0]
[“n-tit-for-tat” 5 10]
```
This means that we run 2^5= 22222=32 combinations of the model with different variations to determine how many agents have the strategy defect, cooperate, unforgiving, random, and tit-for-tat. These strategies have 5 or 10 agents. We do not include the unknown strategy.

Now we have to define what information to save. The default case is the amount of turtles, which is not very useful in our case since it remains constant. More interesting is the information in the plot of the interface.

If we go to the code and look what information is used to plot these graphs, we see that we can use the following information to save for our analysis

```
random-score / (num-random-games)
defect-score / (num-defect-games)
cooperate-score / (num-cooperate-games)
tit-for-tat-score / (num-tit-for-tat-games)
unforgiving-score / (num-unforgiving-games)
```
We don’t want to save the information for every timestep since the information that is saved is the average over all of the timesteps so far. Therefore, we should uncheck Measure runs at every timestep.

We want the model to run 1,000 ticks, so we select a time limit of 1000.

Now we get something like

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_18.png)<br>*
Figure 18.*

Now we click OK and get

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_19.png)<br>*
Figure 19.*

Which means that we have defined 32 runs. Note that we run each parameter settings only once. If we would have defined 10 repetitions, we would get 320 runs. For this exercise we want to keep the runtime short.

Now we have to click on “Run” and get the following:

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_20.png)<br>*
Figure 20.*

We have to decide to save it as a spreadsheet (Excel), a table (ascii text file), both a table and spreadsheet, or whether you don’t want to save the data at all.
When we click on one of the options we are asked where to save the data on the computer.
When we have done this, the computer runs the simulations and stores the data. We will then get the following window:

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_21.png)<br>*
Figure 21.*

We see here how many runs it has done so far. We can speed up the runs by unchecking “Update view” and “Update plots and monitors” so that the computer does not spend time to update the screen for each calculation. And we can put the slider to high speed instead of normal speed. For this exercise it is not very important, but for more complex models we may run BehaviorSpace for many hours, and then it is useful to reduce the time for the calculations by 90%.

Now we can look at the results. By importing the data from the table file into Excel, we get the following picture. We may check the differences in how the information is stored between spreadsheet and table. I prefer to use table for my own analysis.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_5_Fig_22.png)<br>*
Figure 22.*

We found now for a few cases that the defect always strategy is not the best. Since the model is stochastic, you need to run each parameter setting many times to be statistically sure about this.

More information can be found at
http://ccl.northwestern.edu/netlogo/docs/behaviorspace.html.
