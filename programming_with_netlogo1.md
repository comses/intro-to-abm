# Programming with NetLogo(1)
Learning to program in a NetLogo package is mainly a process by learning-by-doing. By working through tutorials and example models, you will become familiar with the basics of the language and where you have to look for solutions to the problems you encounter. A few basic elements of the NetLogo language are discussed in the following paragraphs.
Agents are called turtles in NetLogo. NetLogo has been based on follow up languages of Logo, a procedural programming language developed in the 1960s. The idea in the development of [Logo](http://en.wikipedia.org/wiki/Logo_(programming_language)) is to have a simple language to steer an agent or robot, the turtle. For example, a turtle with a pen strapped to it can be instructed to do simple things like move forward 100 spaces or turn around. The figure below shows you can create a square by having the following sequence of commands:
```
Forward 50
Right 90
Forward 50
Right 90
Forward 50
Right 90
Forward 50
Right 90
```
Where Right 90 means that the turtle will turn right 90 degrees.

<br>



![logo](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/CH_4_Fig_3_logo.png)<br>*Figure 3. Logo.*


From these building blocks you can build more complex shapes likes squares, triangles, circles, etc. Packages like StarLogo and NetLogo simulate populations of turtles and provide them with many more commands. Turtles have coordinates (xcor, ycor), an orientation (heading), and they can move around in the environment of patches.

The cells of the spatial explicit environment are called patches. Patches have coordinates (pxcor, pycor), neighbors and a color. Patches can also include more information like whether it is empty, has an agent on it, or contains grass or weed (like in Figure 1).

There is also an observer perspective. From this perspective, you can define aggregates of the patches and turtles, and define the order in which certain commands need to be executed.

The program consists of a number of procedures which define the actions of the turtles and patches, and in which order they are executed. A procedure starts with ``to`` and ends with ``end.`` As an example we define below two example procedures ``setup`` and ``go.``
```
to setup
  ca            ;; clear the world
  crt 10        ;; make 10 new turtles
end


to go
   ask turtles
   [ fd 1                ;; all turtles move forward one step
      rt random 10       ;; .. and turn their hear a random amount
      lt random 10 ]
end
```
#####We recommend that you implement this model before you continue.
There are three main types of procedures in NetLogo:

*Commands* are a list of actions for the agents to carry out. A command always starts with ``to`` and ends with ``end,`` hence a typical command looks like:
```
to (commandname)

(actions)

end
```
In the following example, the name of the command is draw-polygon, and it uses values of global variables num-sides and size. The other actions (pd, repeat, fd, rt) are primitives, as discussed below. Look up the meaning of these primitives to understand what the command draw-polygon is doing.
```
to draw-polygon
   pd
   repeat num-sides
   [       fd size
     rt (360 / num-sides)]
end
```
*Reporters* are some specific commands. They report the value of a function with a specific input. Sometimes you have a set of actions that you use in different parts of the model. In such a case it is useful to define this sequence as a function. The general layout for a reporter is
```
to-report  (namereporter) [ inputvariables ]

(actions)

end
```
See for example a function that defines the absolute value of a number,
```
to-report absolute-value [number]
  ifelse number >= 0
  [ report number]
  [report 0 – number]
end
```
*Primitives* are built in reporters or commands. The developers of NetLogo have defined a number of common reports and commands that many people use, and then build in directly into NetLogo. If you look at the primitives directory at http://ccl.northwestern.edu/NetLogo/docs/primindex.html (LINK DOESN'T EXIST) you see a large set of primitives like ``turtles,`` ``turtles-here,`` ``ask, clear-all,`` etc. Learning which primitives are available and how to use them will take some practice. The best way to learn this is by looking at example models and see how other models have implemented certain problems.

Variables that are globally defined can be used everywhere in the program and are defined at top of the program
```
globals [ parameter ]
```
or are defined as a slider of switch in the interface.

Also the attributes of turtles and patches are defined globally:
```
turtles-own [attribute]


patches-own [attribute]
```
To update a variable you use the command set, for example
```
set year year + 1
```
You can also define a local variable within a procedure by
```
let variable 0
```
Note that a local variable can only be used within a procedure.

To update a variable for all turtles use the command ``ask.``

You can update the color of all turtles
```
ask turtles [set color red]
```
or of all patches
```
ask patches [set pcolor red]
```
You can also change the color of the patches on which there are turtles
```
ask turtles [set pcolor red]
```
or a specific turtle
```
ask turtle 5 [set color green]
```
or
```
set color-of turtle 5 green
```
or patch
```
ask patch 2 3 [set pcolor green]
```
A more complicated procedure is
```
ask turtles
[
    if (attribute > threshold)
    [
    set attribute attribute – 1
    fd 1
    ]
]
```
In the procedure above the agent is not doing anything if the attribute is less than the threshold. In the following procedure we adjust the earlier procedure to include that agents make a different decision if the attribute is smaller or equal to the threshold. We also will visualize this in the graphical interface by giving the turtle different colors for each condition.
```
ask turtles
[
  ifelse (attribute > threshold)
  [
    set attribute attribute – 1
    set color white
    rt random-float 360
    fd 1
  ][
    set color red
    rt random-float 90
    fd 2
  ]
]
```
*Agentsets* are a subset of the agents, for example all red turtles
```
turtles with [color = red]
```
or all the red turtles on the current patch
```
turtles-here with [color = red]
```
Another example is all the patches at the right part of the screen
```
patches with [pxcor > 0]
```
From the perspective of the “caller,” a turtle of patch, you can define an agentset of all turtles within a certain radius
```
turtles in-radius 3
```
Defining four neighboring patches (north, south, east and west)
```
patches at-points [[1 0] [0 1] [-1 0] [0 -1]]
```
but this can also be defined easier with a primitive
```
neighbors4
```
What are agentsets for? Well you may want to update a specific set of agents, like
```
ask   [….]
```
or check whether there is a specific agentset
```
show any?
```
or count how large the agentset is
```
show count
```
A specific example is the following where the turtle with the lowest fitness is removed
```
ask min-one-of turtles [ fitness ][ die ]
```
Special agentsets are breeds. In fact you define them typically in the setup of your model, like
```
breed [consumers consumer]
```
If you look into the primitive dictionary you see a number of specific primitives for breeds like
```
create-<breed>
create-custom-<breed>
<breed>-here
<breed>-at
```
So that you can use it like
```
ask turtle 100 [ if breed = consumer […]]
```
or, if you want to change the breed of a turtle
```
ask turtle 100 [ set breed consumer ]
```
As mentioned before, learning to use NetLogo is a matter of practicing, for example studying the example models we use, or reimplementing models discussed in papers.

