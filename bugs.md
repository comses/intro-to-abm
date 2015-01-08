#
We will illustrate the principle of evolution with an interactive and fun model in NetLogo. The model Bug Hunt Speeds can be found in the model library in the folder Curriculum Models and the subfolder BEAGLE Evolution. The model has bugs walking around on the landscape. There are six types of bugs who differ in their speed. Hence the variation in the population is speed. You can catch bugs with your mouse. Click with the arrow on a bug and it will disappear. One of the existing bugs will be cloned to keep the population at a stable level. You will see that it is easier to catch slow bugs compared to fast bugs. You act as the selection mechanism and it is likely that the average speed of the remaining bugs will start to increase.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_8_Fig_2.png)<br>*
Figure 2. Screenshot of the Bug Hunt Speed model.*

Figure 3 shows the distribution of the bug variation at the start of the simulation and after a few minutes. Over time there will be more fast bugs and the slow bugs will have become extinct. Figure 4 shows that the average speed is increasing steadily over time.

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_8_Fig_3a.png)![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_8_Fig_3b.png)<br>*
Figure 3. The top graph shows the initial distribution of the six types of bugs; the bottom graph shows the distribution after a few minutes of bug hunting.*

![](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/Ch_8_Fig_4.png)<br>*
Figure 4. The average speed of the bugs over time.*

The results in Figures 3 and 4 reflect a setting [flee] where bugs move when they see a predator nearby as opposed to staying stationary. You may try to catch the bugs with the flee slider turned on and off. What are the differences in the results? Can you explain why?

In the Bug Hunt Speed model some primitives are introduced that we had not seen before. The first one is `in-cone` and is used to model the flee behavior. The primitive `in-cone x y` is called by a turtle and simulates a cone of vision for the turtle. The turtle can see up to distance x and the angle of the cone is y using the current heading of the turtle. If y is equal to 360 the cone is a radius with size x.

In the code of the Bug Hunt Speed model the bugs check whether there are any predators in the cone with a distance of 2 patches and an angle of 120 degrees. Hence the bug cannot look back. If the bug sees a predator it will change its heading 180 degrees away from the predator so that it can flee.
```
ifelse flee? [
  ifelse any? predators in-cone 2 120 [
    set candidate-predator one-of predators in-cone 2  120
    set target-heading 180 + towards candidate-predator
    set heading target-heading
  ]
]
```
An interesting aspect of this model is that you are the predator instead of a computer agent. So how would you model the interaction between the mouse and the model? First it uses `mouse-xcor` and `mouse-ycor` which defines the coordinates of the mouse in the 2D view of the model. Second the model checks whether the mouse button is down by `mouse-down?,` and inside of the view by `mouse-inside?.` If the mouse button is not down or the mouse is not inside of the 2D view, there is no reason to check whether we have caught a bug. Otherwise, we will check whether one of the bugs is inside the radius of the predator.

Even though we use only one predator we still use `ask predators` and `one-of predators.` Since there is only one predator, it will always be our mouse.
```
if not mouse-down? or not mouse-inside? [ stop ]
let prey [bugs in-radius (size / 2)] of one-of predators]
```

